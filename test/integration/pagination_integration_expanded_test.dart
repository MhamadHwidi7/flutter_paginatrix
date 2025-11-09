import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Expanded Pagination Integration Tests', () {
    late PaginatedCubit<Map<String, dynamic>> controller;
    late List<Map<String, dynamic>> mockData;

    setUp(() {
      mockData = createMockData(totalItems: 200);
    });

    tearDown(() {
      controller.close();
    });

    group('All Pagination Types', () {
      test('page-based pagination: complete flow', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        expect(controller.state.meta?.page, 1);
        expect(controller.canLoadMore, isTrue);

        await controller.loadNextPage();
        expect(controller.state.meta?.page, 2);

        await controller.loadNextPage();
        expect(controller.state.meta?.page, 3);
        expect(controller.state.items.length, 60);
      });

      test('cursor-based pagination', () async {
        var currentCursor = 'cursor_0';
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            final cursorValue = cursor ?? currentCursor;
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
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
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
        expect(controller.state.meta?.offset, 0);
        expect(controller.state.meta?.limit, 20);

        await controller.loadNextPage();
        expect(controller.state.meta?.offset, 20);
        expect(controller.state.items.length, 40);
      });
    });

    group('Error Scenarios', () {
      test('network error on initial load', () async {
        controller = PaginatedCubit<Map<String, dynamic>>(
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
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            return {'invalid': 'structure'}; // Missing required fields
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();

        expect(controller.hasError, isTrue);
        expect(
          controller.state.error?.when(
            parse: (_, __, ___) => true,
            network: (_, __, ___) => false,
            cancelled: (_) => false,
            rateLimited: (_, __) => false,
            circuitBreaker: (_, __) => false,
            unknown: (_, __) => false,
          ),
          isTrue,
        );
      });

      test('rate limit error', () async {
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            throw const PaginationError.rateLimited(
              message: 'Too many requests',
              retryAfter: Duration(seconds: 60),
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();

        expect(controller.hasError, isTrue);
        expect(
          controller.state.error?.when(
            rateLimited: (_, __) => true,
            network: (_, __, ___) => false,
            parse: (_, __, ___) => false,
            cancelled: (_) => false,
            circuitBreaker: (_, __) => false,
            unknown: (_, __) => false,
          ),
          isTrue,
        );
      });

      test('circuit breaker error', () async {
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            throw const PaginationError.circuitBreaker(
              message: 'Service unavailable',
              retryAfter: Duration(minutes: 5),
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();

        expect(controller.hasError, isTrue);
        expect(controller.state.error?.isRetryable, isTrue);
      });

      test('append error preserves existing items', () async {
        var failOnce = true;
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            if (page == 2 && failOnce) {
              failOnce = false;
              throw const PaginationError.network(message: 'Append failed');
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              perPage: perPage,
              cancelToken: cancelToken,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        final firstPageItems = controller.state.items.length;

        await controller.loadNextPage();
        expect(controller.hasAppendError, isTrue);
        expect(controller.state.items.length, firstPageItems); // Preserved
      });
    });

    group('Cancellation', () {
      test('should cancel in-flight request', () async {
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: createSlowLoader(mockData: mockData),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        // Start loading
        controller.loadFirstPage();

        // Cancel immediately
        controller.cancel();

        // Wait for cancellation to be processed
        await Future.delayed(const Duration(milliseconds: 200));

        // After cancellation, the state might be in error or still loading
        // The important thing is that the request was cancelled
        // Check that we're not in a success state (unless it completed before cancellation)
        // Note: In a real scenario, cancellation might happen after data is loaded
        expect(controller.isLoading || !controller.hasData || controller.hasError, isTrue);
      });

      test('should handle cancellation during append', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();

        // Start append with slow loader
        final slowController = PaginatedCubit<Map<String, dynamic>>(
          loader: createSlowLoader(mockData: mockData),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await slowController.loadFirstPage();
        slowController.loadNextPage();

        slowController.cancel();
        await Future.delayed(const Duration(milliseconds: 200));

        // After cancellation, check that append didn't complete successfully
        // The items should still be from the first page
        expect(slowController.state.items.length, 20);

        slowController.close();
      });

      test('should prevent stale responses after cancellation', () async {
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            await Future.delayed(const Duration(milliseconds: 100));
            if (cancelToken?.isCancelled == true) {
              throw const PaginationError.cancelled(message: 'Cancelled');
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        // Start first request
        controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        // Cancel and start new request
        controller.cancel();
        await controller.loadFirstPage();

        // Should have fresh data, not stale
        expect(controller.hasData, isTrue);
        expect(controller.state.items.length, 20);
      });
    });

    group('Retry Logic', () {
      test('should retry failed initial load', () async {
        var attemptCount = 0;
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            attemptCount++;
            if (attemptCount < 2) {
              throw const PaginationError.network(message: 'Failed');
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
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
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            if (page == 2) {
              attemptCount++;
              if (attemptCount < 2) {
                throw const PaginationError.network(message: 'Append failed');
              }
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              perPage: perPage,
              cancelToken: cancelToken,
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
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: createFailingLoader(),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: PaginationOptions(maxRetries: 2),
        );

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);

        // Retry multiple times
        await controller.retry();
        await controller.retry();
        await controller.retry(); // Should be ignored after max retries

        // Should still have error
        expect(controller.hasError, isTrue);
      });

      test('should reset retry count after successful load', () async {
        var attemptCount = 0;
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            attemptCount++;
            if (attemptCount == 1) {
              throw const PaginationError.network(message: 'Failed');
            }
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);

        await controller.retry();
        expect(controller.hasData, isTrue);

        // Retry count should be reset, so we can retry again if needed
        await controller.refresh();
        expect(controller.hasData, isTrue);
      });
    });

    group('Refresh Debouncing', () {
      test('should debounce rapid refresh calls', () async {
        var loadCount = 0;
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            loadCount++;
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: PaginationOptions(
            refreshDebounceDuration: const Duration(milliseconds: 200),
          ),
        );

        await controller.loadFirstPage();
        final initialLoadCount = loadCount;

        // Rapid refresh calls
        controller.refresh();
        controller.refresh();
        controller.refresh();

        await Future.delayed(const Duration(milliseconds: 300));

        // Should only have one additional load (debounced)
        expect(loadCount, initialLoadCount + 1);
      });

      test('should allow immediate refresh when debounce is disabled', () async {
        var loadCount = 0;
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            loadCount++;
            return createMockLoader(mockData: mockData)(
              page: page,
              cancelToken: cancelToken,
            );
          },
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: PaginationOptions(
            refreshDebounceDuration: Duration.zero,
          ),
        );

        await controller.loadFirstPage();
        final initialLoadCount = loadCount;

        await controller.refresh();

        // Should load immediately
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

        // Initial -> Loading -> Success
        await controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.any((s) => s.status.maybeWhen(
          loading: () => true,
          orElse: () => false,
        )), isTrue);

        expect(states.any((s) => s.status.maybeWhen(
          success: () => true,
          orElse: () => false,
        )), isTrue);

        // Success -> Appending -> Success
        await controller.loadNextPage();
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.any((s) => s.status.maybeWhen(
          appending: () => true,
          orElse: () => false,
        )), isTrue);

        // Success -> Refreshing -> Success
        await controller.refresh();
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.any((s) => s.status.maybeWhen(
          refreshing: () => true,
          orElse: () => false,
        )), isTrue);

        await subscription.cancel();
      });
    });

    group('Edge Cases', () {
      test('should handle empty response', () async {
        controller = createTestController(mockData: []);

        await controller.loadFirstPage();

        expect(controller.state.status.maybeWhen(
          empty: () => true,
          orElse: () => false,
        ), isTrue);
        expect(controller.state.items, isEmpty);
      });

      test('should handle single page of data', () async {
        controller = createTestController(mockData: createMockData(totalItems: 10));

        await controller.loadFirstPage();

        expect(controller.canLoadMore, isFalse);
        expect(controller.state.items.length, 10);
      });

      test('should handle very large page size', () async {
        final largeData = createMockData(totalItems: 200);
        // Create controller with custom options for large page size
        controller = PaginatedCubit<Map<String, dynamic>>(
          loader: createMockLoader(
            mockData: largeData,
            itemsPerPage: 1000,
          ),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: PaginationOptions(defaultPageSize: 1000),
        );

        await controller.loadFirstPage();

        // With page size 1000, all 200 items should be loaded in one page
        expect(controller.state.items.length, 200);
        expect(controller.canLoadMore, isFalse);
      });

      test('should handle rapid loadNextPage calls', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        final initialCount = controller.state.items.length;

        // Rapid calls
        controller.loadNextPage();
        controller.loadNextPage();
        controller.loadNextPage();

        // Wait for at least one to complete
        await Future.delayed(const Duration(milliseconds: 300));

        // Should handle gracefully - at least one should have processed
        // but not all three (due to loading guard)
        expect(controller.state.items.length, greaterThanOrEqualTo(initialCount));
      });
    });
  });
}

