import 'package:dio/dio.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Expanded Pagination Integration Tests', () {
    late PaginatrixCubit<Map<String, dynamic>> controller;
    late List<Map<String, dynamic>> mockData;

    setUp(() {
      mockData = createMockData(totalItems: 200);
    });

    tearDown(() {
      try {
        if (!controller.isClosed) {
          controller.close();
        }
      } catch (e) {
        // Controller may not be initialized if test failed early
      }
    });

    group('All Pagination Types', () {
      test('page-based pagination: complete flow', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        expect(controller.state.meta?.page, 1);
        expect(controller.canLoadMore, isTrue);

        await controller.loadNextPage();
        expect(controller.state.meta?.page, 2);
        expect(controller.state.items.length, 40);
      });

      test('cursor-based pagination', () async {
        var currentCursor = 'cursor_0';
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            final items = mockData.take(20).toList();
            currentCursor = 'cursor_${items.length}';
            return {
              'data': items,
              'meta': {
                'next_cursor': currentCursor,
                'has_more': items.length == 20,
              },
            };
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.cursorBased),
        );

        await controller.loadFirstPage();
        expect(controller.state.meta?.nextCursor, isNotNull);
        expect(controller.canLoadMore, isTrue);

        await controller.loadNextPage();
        expect(controller.state.items.length, 40);
      });

      test('offset-based pagination', () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            final start = offset ?? 0;
            final size = limit ?? 20;
            final items = mockData.skip(start).take(size).toList();
            return {
              'data': items,
              'meta': {
                'offset': start,
                'limit': size,
                'total': mockData.length,
                'has_more': start + size < mockData.length,
              },
            };
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.offsetBased),
        );

        await controller.loadFirstPage();
        expect(controller.state.meta, isNotNull);
        expect(controller.canLoadMore, isTrue);

        await controller.loadNextPage();
        expect(controller.state.items.length, greaterThanOrEqualTo(20));
      });
    });

    group('Error Scenarios', () {
      test('network error on initial load', () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createFailingLoader(message: 'Connection failed'),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);
        expect(controller.state.error?.isRetryable, isTrue);
        expect(controller.state.items, isEmpty);
      });

      test('parse error on invalid response', () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async =>
              {'invalid': 'structure'},
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);
        expect(
          controller.state.error?.maybeWhen(
            parse: (_, __, ___) => true,
            orElse: () => false,
          ),
          isTrue,
        );
      });

      test('rate limit and circuit breaker errors', () async {
        // Rate limit
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createFailingLoader(
            errorFactory: () => const PaginationError.rateLimited(
              message: 'Too many requests',
              retryAfter: Duration(seconds: 60),
            ),
          ),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);
        expect(
          controller.state.error?.maybeWhen(
            rateLimited: (_, __) => true,
            orElse: () => false,
          ),
          isTrue,
        );
        controller.close();

        // Circuit breaker
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createFailingLoader(
            errorFactory: () => const PaginationError.circuitBreaker(
              message: 'Service unavailable',
              retryAfter: Duration(minutes: 5),
            ),
          ),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);
        expect(controller.state.error?.isRetryable, isTrue);
      });

      test('append error preserves existing items', () async {
        var failOnce = true;
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            if (page == 2 && failOnce) {
              failOnce = false;
              throw const PaginationError.network(message: 'Append failed');
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
              query: query,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        final firstPageItems = controller.state.items.length;

        await controller.loadNextPage();
        expect(controller.hasAppendError, isTrue);
        expect(controller.state.items.length, firstPageItems);
      });
    });

    group('Cancellation', () {
      test('should cancel in-flight request', () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createSlowLoader(mockData: mockData),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        final loadFuture = controller.loadFirstPage();
        controller.cancel();
        await Future.delayed(const Duration(milliseconds: 200));

        try {
          await loadFuture;
        } catch (e) {
          // Expected if cancelled
        }

        expect(
          controller.isLoading || !controller.hasData || controller.hasError,
          isTrue,
        );
      });

      test('should prevent stale responses after cancellation', () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            await Future.delayed(const Duration(milliseconds: 100));
            if (cancelToken?.isCancelled ?? false) {
              throw const PaginationError.cancelled(message: 'Cancelled');
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
              query: query,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        final firstLoad = controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        controller.cancel();
        await Future.delayed(const Duration(milliseconds: 50));

        await controller.loadFirstPage();
        expect(controller.hasData, isTrue);
        expect(controller.state.items.length, 20);

        try {
          await firstLoad.timeout(const Duration(milliseconds: 100));
        } catch (e) {
          // Expected if cancelled
        }
      });

      test('should never mutate state after cancellation', () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createSlowLoader(mockData: mockData),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        final loadFuture = controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        final itemsBeforeCancel = List.from(controller.state.items);
        controller.cancel();
        await Future.delayed(const Duration(milliseconds: 200));

        final stateAfterCancel = controller.state;
        if (stateAfterCancel.status.maybeWhen(
              success: () => true,
              orElse: () => false,
            ) &&
            stateAfterCancel.items.length > itemsBeforeCancel.length) {
          fail(
            'Cancelled request mutated state: items increased from ${itemsBeforeCancel.length} to ${stateAfterCancel.items.length}',
          );
        }

        try {
          await loadFuture;
        } catch (e) {
          // Expected if cancelled
        }
      });

      test('should drop stale responses using generation guard', () async {
        var requestCount = 0;
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            final currentRequest = ++requestCount;
            final delay = currentRequest == 1
                ? const Duration(milliseconds: 200)
                : const Duration(milliseconds: 50);

            await Future.delayed(delay);
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
              query: query,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        final firstLoad = controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        final secondLoad = controller.loadFirstPage();
        await secondLoad;

        try {
          await firstLoad.timeout(const Duration(milliseconds: 300));
        } catch (e) {
          // May timeout or be cancelled
        }

        expect(controller.hasData, isTrue);
        expect(controller.state.items.length, 20);
        expect(controller.hasError, isFalse);
      });
    });

    group('Retry Logic', () {
      test('should retry failed initial load', () async {
        var attemptCount = 0;
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            attemptCount++;
            if (attemptCount < 2) {
              throw const PaginationError.network(message: 'Failed');
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
              query: query,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);

        await controller.retry();
        expect(controller.hasData, isTrue);
        expect(attemptCount, 2);
      });

      test('should retry failed append', () async {
        var attemptCount = 0;
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            if (page == 2) {
              attemptCount++;
              if (attemptCount < 2) {
                throw const PaginationError.network(message: 'Append failed');
              }
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
              query: query,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        await controller.loadNextPage();
        expect(controller.hasAppendError, isTrue);

        await controller.retry();
        expect(controller.hasAppendError, isFalse);
        expect(controller.state.items.length, 40);
      });

      test('should respect max retry limit', () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createFailingLoader(),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: const PaginationOptions(maxRetries: 2),
        );

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);

        await controller.retry();
        await controller.retry();
        await controller.retry(); // Should be ignored after max retries

        expect(controller.hasError, isTrue);
      });
    });

    group('Refresh Debouncing', () {
      test('should debounce rapid refresh calls', () async {
        var loadCount = 0;
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            loadCount++;
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
              query: query,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: const PaginationOptions(
            refreshDebounceDuration: Duration(milliseconds: 200),
          ),
        );

        await controller.loadFirstPage();
        final initialLoadCount = loadCount;

        controller.refresh();
        controller.refresh();
        controller.refresh();

        await Future.delayed(const Duration(milliseconds: 300));

        expect(loadCount, initialLoadCount + 1);
      });

      test('should allow immediate refresh when debounce is disabled',
          () async {
        var loadCount = 0;
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
            QueryCriteria? query,
          }) async {
            loadCount++;
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
              query: query,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: const PaginationOptions(
            refreshDebounceDuration: Duration.zero,
          ),
        );

        await controller.loadFirstPage();
        final initialLoadCount = loadCount;

        await controller.refresh();
        expect(loadCount, initialLoadCount + 1);
      });
    });

    group('State Transitions', () {
      test('should transition through all states correctly', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 50),
        );

        final states = <PaginationState>[];
        final subscription = controller.stream.listen(states.add);

        await controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 100));

        expect(
          states.any((s) => s.status.maybeWhen(
                loading: () => true,
                orElse: () => false,
              )),
          isTrue,
        );
        expect(
          states.any((s) => s.status.maybeWhen(
                success: () => true,
                orElse: () => false,
              )),
          isTrue,
        );

        await controller.loadNextPage();
        await Future.delayed(const Duration(milliseconds: 100));

        expect(
          states.any((s) => s.status.maybeWhen(
                appending: () => true,
                orElse: () => false,
              )),
          isTrue,
        );

        await subscription.cancel();
      });
    });

    group('Edge Cases', () {
      test('should handle empty response', () async {
        controller = createTestController(mockData: []);

        await controller.loadFirstPage();

        expect(
          controller.state.status.maybeWhen(
            empty: () => true,
            orElse: () => false,
          ),
          isTrue,
        );
        expect(controller.state.items, isEmpty);
      });

      test('should handle single page of data', () async {
        controller = createTestController(
          mockData: createMockData(totalItems: 10),
        );

        await controller.loadFirstPage();

        expect(controller.canLoadMore, isFalse);
        expect(controller.state.items.length, 10);
      });

      test('should handle rapid loadNextPage calls', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        final initialCount = controller.state.items.length;

        controller.loadNextPage();
        controller.loadNextPage();
        controller.loadNextPage();

        await Future.delayed(const Duration(milliseconds: 300));

        expect(
          controller.state.items.length,
          greaterThanOrEqualTo(initialCount),
        );
      });
    });
  });
}
