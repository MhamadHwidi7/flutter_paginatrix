import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('PaginatedController', () {
    late PaginatedController<Map<String, dynamic>> controller;
    late List<Map<String, dynamic>> mockData;

    setUp(() {
      mockData = createMockData(totalItems: 100);
    });

    tearDown(() {
      controller.dispose();
    });

    group('Initialization', () {
      test('should create controller with initial state', () {
        controller = createTestController(mockData: mockData);

        expect(controller.state.items, isEmpty);
        expect(controller.isLoading, isFalse);
        expect(controller.hasData, isFalse);
        expect(controller.hasError, isFalse);
        expect(controller.canLoadMore, isFalse);
      });

      test('should have accessible stream', () {
        controller = createTestController(mockData: mockData);

        expect(controller.stream, isNotNull);
        expect(controller.stream, isA<Stream<PaginationState>>());
      });
    });

    group('Loading First Page', () {
      test('should load first page successfully', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();

        expect(controller.hasData, isTrue);
        expect(controller.state.items.length, 20);
        expect(controller.state.meta?.page, 1);
        expect(controller.state.meta?.perPage, 20);
        expect(controller.state.meta?.total, 100);
        expect(controller.canLoadMore, isTrue);
        expect(controller.state.error, isNull);
      });

      test('should emit loading state before success', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 100),
        );

        final states = <PaginationState>[];
        final subscription = controller.stream.listen(states.add);

        controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states.any((s) => s.isLoading), isTrue);

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.last.hasData, isTrue);
      });

      test('should not load if already loading', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 200),
        );

        final firstLoad = controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        // Try to load again while first is loading
        await controller.loadFirstPage();

        await firstLoad;

        // Should only have one page loaded
        expect(controller.state.items.length, 20);
      });

      test('should replace existing items on loadFirstPage', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        await controller.loadNextPage();
        expect(controller.state.items.length, 40);

        await controller.loadFirstPage();
        expect(controller.state.items.length, 20);
        expect(controller.state.meta?.page, 1);
      });
    });

    group('Loading Next Page', () {
      test('should append next page to existing items', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        expect(controller.state.items.length, 20);

        await controller.loadNextPage();
        expect(controller.state.items.length, 40);
        expect(controller.state.meta?.page, 2);
      });

      test('should not load next page if cannot load more', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        for (int i = 0; i < 4; i++) {
          await controller.loadNextPage();
        }

        expect(controller.canLoadMore, isFalse);
        final itemCountBefore = controller.state.items.length;

        await controller.loadNextPage();
        expect(controller.state.items.length, itemCountBefore);
      });

      test('should not load next page if already loading', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 200),
        );

        await controller.loadFirstPage();

        final firstNextPage = controller.loadNextPage();
        await Future.delayed(const Duration(milliseconds: 50));

        // Try to load again while first is loading
        await controller.loadNextPage();

        await firstNextPage;

        // Should only have two pages loaded
        expect(controller.state.items.length, 40);
      });

      test('should emit appending state before success', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 100),
        );

        await controller.loadFirstPage();

        final states = <PaginationState>[];
        final subscription = controller.stream.listen(states.add);

        controller.loadNextPage();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(
          states.any((s) => s.status.maybeWhen(
            appending: () => true,
            orElse: () => false,
          )),
          isTrue,
        );

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();
      });
    });

    group('Refresh', () {
      test('should refresh and replace all items', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        await controller.loadNextPage();
        expect(controller.state.items.length, 40);

        await controller.refresh();
        expect(controller.state.items.length, 20);
        expect(controller.state.meta?.page, 1);
      });

      test('should update lastLoadedAt timestamp on refresh', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        final firstLoadTime = controller.state.lastLoadedAt;
        expect(firstLoadTime, isNotNull);

        await Future.delayed(const Duration(milliseconds: 10));
        await controller.refresh();

        expect(controller.state.lastLoadedAt, isNotNull);
        expect(
          controller.state.lastLoadedAt!.isAfter(firstLoadTime!),
          isTrue,
        );
      });

      test('should emit refreshing state before success', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 100),
        );

        await controller.loadFirstPage();

        final states = <PaginationState>[];
        final subscription = controller.stream.listen(states.add);

        controller.refresh();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(
          states.any((s) => s.status.maybeWhen(
            refreshing: () => true,
            orElse: () => false,
          )),
          isTrue,
        );

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();
      });
    });

    group('Error Handling', () {
      test('should handle initial load error', () async {
        controller = PaginatedController<Map<String, dynamic>>(
          loader: createFailingLoader(),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        await controller.loadFirstPage();

        expect(controller.hasError, isTrue);
        expect(controller.state.error, isNotNull);
        expect(controller.state.items, isEmpty);
      });

      test('should retry initial error successfully', () async {
        var shouldFail = true;
        controller = PaginatedController<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            if (shouldFail) {
              shouldFail = false;
              throw const PaginationError.network(message: 'Network error');
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
        expect(controller.hasError, isTrue);

        await controller.retry();
        expect(controller.hasData, isTrue);
        expect(controller.hasError, isFalse);
        expect(controller.state.items.length, 20);
      });

      test('should handle append error without losing existing data', () async {
        var shouldFail = false;
        controller = PaginatedController<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            if (page == 2 && !shouldFail) {
              shouldFail = true;
              throw const PaginationError.network(
                message: 'Failed to load next page',
              );
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
        expect(controller.state.items.length, 20);

        await controller.loadNextPage();
        expect(controller.state.appendError, isNotNull);
        expect(controller.state.items.length, 20); // Existing items preserved
      });

      test('should retry append error', () async {
        var failCount = 0;
        controller = PaginatedController<Map<String, dynamic>>(
          loader: ({
            int? page,
            int? perPage,
            int? offset,
            int? limit,
            String? cursor,
            CancelToken? cancelToken,
          }) async {
            if (page == 2 && failCount < 1) {
              failCount++;
              throw const PaginationError.network(
                message: 'Append error',
              );
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
        expect(controller.state.appendError, isNotNull);

        await controller.loadNextPage(); // Retry
        expect(controller.state.appendError, isNull);
        expect(controller.state.items.length, 40);
      });
    });

    group('Request Cancellation', () {
      test('should cancel in-flight request', () async {
        controller = PaginatedController<Map<String, dynamic>>(
          loader: createSlowLoader(
            mockData: mockData,
            delay: const Duration(seconds: 5),
          ),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(controller.state.isLoading, isTrue);

        controller.cancel();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(() => controller.cancel(), returnsNormally);
      });

      test('should prevent stale responses using generation', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 200),
        );

        // Start first load
        final firstLoad = controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        // Start second load (should cancel first)
        final secondLoad = controller.loadFirstPage();
        await Future.delayed(const Duration(milliseconds: 50));

        // Cancel second load
        controller.cancel();

        // Wait for both to potentially complete
        try {
          await firstLoad;
        } catch (_) {}
        try {
          await secondLoad;
        } catch (_) {}

        // State should reflect the cancellation, not stale data
        await Future.delayed(const Duration(milliseconds: 100));
        expect(controller.state.isLoading, isFalse);
      });
    });

    group('Clear Data', () {
      test('should clear all data and reset to initial state', () async {
        controller = createTestController(mockData: mockData);

        await controller.loadFirstPage();
        await controller.loadNextPage();
        expect(controller.hasData, isTrue);
        expect(controller.state.items.length, 40);

        controller.clear();

        expect(controller.hasData, isFalse);
        expect(controller.state.items, isEmpty);
        expect(controller.state.meta, isNull);
        expect(controller.state.error, isNull);
      });
    });

    group('State Getters', () {
      test('should correctly report canLoadMore', () async {
        controller = createTestController(mockData: mockData);

        expect(controller.canLoadMore, isFalse); // No data yet

        await controller.loadFirstPage();
        expect(controller.canLoadMore, isTrue); // Has more pages

        // Load all pages
        for (int i = 0; i < 4; i++) {
          await controller.loadNextPage();
        }

        expect(controller.canLoadMore, isFalse); // No more pages
      });

      test('should correctly report isLoading', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 100),
        );

        expect(controller.isLoading, isFalse);

        final loadFuture = controller.loadFirstPage();
        expect(controller.isLoading, isTrue);

        await loadFuture;
        expect(controller.isLoading, isFalse);
      });

      test('should correctly report hasData', () async {
        controller = createTestController(mockData: mockData);

        expect(controller.hasData, isFalse);

        await controller.loadFirstPage();
        expect(controller.hasData, isTrue);
      });

      test('should correctly report hasError', () async {
        controller = PaginatedController<Map<String, dynamic>>(
          loader: createFailingLoader(),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        );

        expect(controller.hasError, isFalse);

        await controller.loadFirstPage();
        expect(controller.hasError, isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle empty response', () async {
        final emptyData = <Map<String, dynamic>>[];
        controller = createTestController(mockData: emptyData);

        await controller.loadFirstPage();

        expect(controller.state.items, isEmpty);
        expect(controller.canLoadMore, isFalse);
      });

      test('should handle single page of data', () async {
        final singlePageData = createMockData(totalItems: 10);
        controller = createTestController(mockData: singlePageData);

        await controller.loadFirstPage();

        expect(controller.state.items.length, 10);
        expect(controller.canLoadMore, isFalse);
      });

      test('should handle very large dataset', () async {
        final largeData = createMockData(totalItems: 10000);
        controller = createTestController(mockData: largeData);

        await controller.loadFirstPage();
        expect(controller.state.items.length, 20);

        for (int i = 0; i < 10; i++) {
          await controller.loadNextPage();
        }

        expect(controller.state.items.length, 220);
        expect(controller.canLoadMore, isTrue);
      });

      test('should handle rapid successive calls gracefully', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 100),
        );

        // Rapidly call loadFirstPage multiple times
        controller.loadFirstPage();
        controller.loadFirstPage();
        controller.loadFirstPage();

        await Future.delayed(const Duration(milliseconds: 200));

        // Should only have one page loaded
        expect(controller.state.items.length, 20);
      });
    });

    group('Stream Behavior', () {
      test('should emit state changes through stream', () async {
        controller = createTestController(mockData: mockData);

        final states = <PaginationState>[];
        final subscription = controller.stream.listen(states.add);

        // Start with initial state
        states.add(controller.state);

        await controller.loadFirstPage();
        await controller.loadNextPage();

        await Future.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        expect(states.length, greaterThan(0));
        final lastState = states.last;
        expect(lastState.hasData, isTrue);
        expect(lastState.items.length, 40);
      });

      test('should handle multiple stream listeners', () async {
        controller = createTestController(mockData: mockData);

        final states1 = <PaginationState>[];
        final states2 = <PaginationState>[];

        final sub1 = controller.stream.listen(states1.add);
        final sub2 = controller.stream.listen(states2.add);

        // Start with initial state
        states1.add(controller.state);
        states2.add(controller.state);

        await controller.loadFirstPage();

        await Future.delayed(const Duration(milliseconds: 50));
        await sub1.cancel();
        await sub2.cancel();

        expect(states1.length, greaterThan(0));
        expect(states2.length, greaterThan(0));
        if (states1.isNotEmpty && states2.isNotEmpty) {
          expect(states1.last.items.length, states2.last.items.length);
        }
      });
    });
  });
}
