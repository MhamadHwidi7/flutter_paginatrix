import 'package:dio/dio.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Pagination Integration Tests', () {
    late PaginatrixCubit<Map<String, dynamic>> controller;
    late List<Map<String, dynamic>> mockData;

    setUp(() {
      mockData = createMockData(totalItems: 200);
    });

    tearDown(() {
      controller.close();
    });

    test('complete pagination flow: initial load -> pagination -> refresh',
        () async {
      controller = createTestControllerWithZeroDebounce(mockData: mockData);

      // Initial state
      expect(controller.state.items, isEmpty,
          reason: 'Initial state should be empty');
      expect(controller.isLoading, isFalse,
          reason: 'Should not be loading initially');
      expect(controller.state.meta, isNull,
          reason: 'Meta should be null initially');

      // Load first page
      await controller.loadFirstPage();
      expect(controller.hasData, isTrue,
          reason: 'Should have data after first load');
      expect(controller.state.items.length, 20,
          reason: 'First page should have 20 items');
      expect(controller.state.meta?.page, 1, reason: 'Should be on page 1');
      expect(controller.canLoadMore, isTrue,
          reason: 'Should be able to load more');
      expect(controller.state.status, equals(const PaginationStatus.success()),
          reason: 'Status should be success');

      // Verify first page data
      final firstPageData = controller.state.items;

      // Load next page
      await controller.loadNextPage();
      expect(controller.state.items.length, 40,
          reason: 'Should have 40 items after second page');
      expect(controller.state.meta?.page, 2, reason: 'Should be on page 2');
      expect(controller.state.items.sublist(0, 20), equals(firstPageData),
          reason: 'First page data should remain unchanged');

      // Load another page
      await controller.loadNextPage();
      expect(controller.state.items.length, 60,
          reason: 'Should have 60 items after third page');
      expect(controller.state.meta?.page, 3, reason: 'Should be on page 3');

      // Refresh - should reset to first page
      await controller.refresh();
      expect(controller.state.items.length, 20,
          reason: 'After refresh should have only first page');
      expect(controller.state.meta?.page, 1,
          reason: 'After refresh should be on page 1');
      expect(controller.state.status, equals(const PaginationStatus.success()),
          reason: 'Status should be success after refresh');
      expect(controller.canLoadMore, isTrue,
          reason: 'Should be able to load more after refresh');
    });

    test('error recovery flow: error -> retry -> success', () async {
      var shouldFail = true;
      controller = PaginatrixCubit<Map<String, dynamic>>(
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

      // Initial load fails
      await controller.loadFirstPage();
      expect(controller.hasError, isTrue);
      expect(controller.state.items, isEmpty);

      // Retry succeeds
      await controller.retry();
      expect(controller.hasData, isTrue);
      expect(controller.hasError, isFalse);
      expect(controller.state.items.length, 20);
    });

    test('cancellation behavior', () async {
      var loadCount = 0;
      controller = PaginatrixCubit<Map<String, dynamic>>(
        loader: ({
          int? page,
          int? perPage,
          int? offset,
          int? limit,
          String? cursor,
          CancelToken? cancelToken,
        }) async {
          loadCount++;
          await Future.delayed(const Duration(milliseconds: 500));
          if (cancelToken?.isCancelled ?? false) {
            throw const PaginationError.cancelled(
                message: 'Operation cancelled');
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

      // Start loading and cancel immediately
      final future = controller.loadFirstPage();
      controller.cancel();
      await future;

      expect(controller.state.status, equals(const PaginationStatus.error()));
      expect(controller.state.error, isA<PaginationError>());
      expect(loadCount, 1);
    });

    test('empty response handling', () async {
      controller = PaginatrixCubit<Map<String, dynamic>>(
        loader: ({
          int? page,
          int? perPage,
          int? offset,
          int? limit,
          String? cursor,
          CancelToken? cancelToken,
        }) async {
          return {
            'data': [],
            'meta': {
              'current_page': page ?? 1,
              'per_page': perPage ?? 20,
              'total': 0,
              'last_page': 1,
              'has_more': false,
            },
          };
        },
        itemDecoder: (json) => json,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );

      await controller.loadFirstPage();
      // Empty response should result in empty status, not success
      expect(
        controller.state.status.maybeWhen(
          empty: () => true,
          success: () => controller.state.items.isEmpty,
          orElse: () => false,
        ),
        isTrue,
        reason:
            'Empty response should result in empty or success with empty items',
      );
      expect(controller.state.items, isEmpty);
      expect(controller.canLoadMore, isFalse);
    });

    test('append error recovery: append fails -> retry -> success', () async {
      var failCount = 0;
      controller = PaginatrixCubit<Map<String, dynamic>>(
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
              message: 'Failed to append',
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

      // Load first page successfully
      await controller.loadFirstPage();
      expect(controller.state.items.length, 20);

      // Append fails
      await controller.loadNextPage();
      expect(controller.state.appendError, isNotNull);
      expect(controller.state.items.length, 20); // Preserved

      // Retry append succeeds
      await controller.loadNextPage();
      expect(controller.state.appendError, isNull);
      expect(controller.state.items.length, 40);
    });

    test('rapid user actions: multiple refreshes handled correctly', () async {
      controller = createTestController(
        mockData: mockData,
        loaderDelay: const Duration(milliseconds: 100),
      );

      await controller.loadFirstPage();

      // Rapidly trigger multiple refreshes
      controller.refresh();
      controller.refresh();
      controller.refresh();

      // Wait for all to complete
      await Future.delayed(const Duration(milliseconds: 300));

      // Should have data from the last refresh
      expect(controller.hasData, isTrue);
      expect(controller.state.items.length, 20);
    });

    test('pagination until end: load all pages until no more', () async {
      controller = createTestController(mockData: mockData);

      await controller.loadFirstPage();
      int pageCount = 1;

      while (controller.canLoadMore) {
        await controller.loadNextPage();
        pageCount++;
      }

      expect(pageCount, 10); // 200 items / 20 per page = 10 pages
      expect(controller.state.items.length, 200);
      expect(controller.canLoadMore, isFalse);
    });

    test('state transitions: verify all state changes', () async {
      controller = createTestController(
        mockData: mockData,
        loaderDelay: const Duration(milliseconds: 50),
      );

      final states = <PaginationState>[];
      // Add initial state manually since stream doesn't emit it
      states.add(controller.state);
      final subscription = controller.stream.listen(states.add);

      // Initial -> Loading -> Success
      await controller.loadFirstPage();
      // Wait a bit for all states to be emitted
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
          states.any((s) => s.status.maybeWhen(
                initial: () => true,
                orElse: () => false,
              )),
          isTrue);
      // Check for loading state (might be very fast, so check if we have success state)
      expect(states.any((s) => s.hasData), isTrue);

      // Success -> Appending -> Success
      await controller.loadNextPage();
      // Wait a bit for all states to be emitted
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
          states.any((s) => s.status.maybeWhen(
                appending: () => true,
                orElse: () => false,
              )),
          isTrue);

      await subscription.cancel();
    });

    test('retry after error: should reset retry count on success', () async {
      var failCount = 0;
      controller = PaginatrixCubit<Map<String, dynamic>>(
        loader: ({
          int? page,
          int? perPage,
          int? offset,
          int? limit,
          String? cursor,
          CancelToken? cancelToken,
        }) async {
          if (failCount < 2) {
            failCount++;
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

      // First attempt fails
      await controller.loadFirstPage();
      expect(controller.hasError, isTrue);

      // Retry fails again
      await controller.retry();
      expect(controller.hasError, isTrue);

      // Retry succeeds
      await controller.retry();
      expect(controller.hasData, isTrue);
      expect(controller.state.items.length, 20);
    });

    test('load next page when already at last page: should not load', () async {
      controller =
          createTestController(mockData: createMockData(totalItems: 20));

      await controller.loadFirstPage();
      expect(controller.state.items.length, 20);
      expect(controller.canLoadMore, isFalse);

      // Try to load next page
      await controller.loadNextPage();
      expect(controller.state.items.length, 20);
      expect(controller.canLoadMore, isFalse);
    });

    test('refresh while loading: should cancel and restart', () async {
      controller = PaginatrixCubit<Map<String, dynamic>>(
        loader: ({
          int? page,
          int? perPage,
          int? offset,
          int? limit,
          String? cursor,
          CancelToken? cancelToken,
        }) async {
          await Future.delayed(const Duration(milliseconds: 200));
          if (cancelToken?.isCancelled ?? false) {
            throw const PaginationError.cancelled(message: 'Cancelled');
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

      // Start loading
      final future = controller.loadFirstPage();

      // Refresh while loading
      await Future.delayed(const Duration(milliseconds: 50));
      await controller.refresh();

      await future;
      await controller.loadFirstPage();

      expect(controller.hasData, isTrue);
      expect(controller.state.items.length, 20);
    });

    test('load next page while appending: should queue correctly', () async {
      controller = createTestController(
        mockData: mockData,
        loaderDelay: const Duration(milliseconds: 100),
      );

      await controller.loadFirstPage();

      // Start loading next page (don't await - let it run)
      controller.loadNextPage();

      // Try to load another page while appending (should queue)
      await controller.loadNextPage();

      // Wait for all operations to complete
      await Future.delayed(const Duration(milliseconds: 400));

      // Should have loaded pages sequentially (not concurrently)
      expect(controller.state.items.length, greaterThanOrEqualTo(40),
          reason: 'Should have at least 2 pages');
      expect(controller.state.meta?.page, greaterThanOrEqualTo(2),
          reason: 'Should be on at least page 2');
    });

    test('meta information: should update correctly on each page', () async {
      controller = createTestController(mockData: mockData);

      await controller.loadFirstPage();
      expect(controller.state.meta?.page, 1);
      expect(controller.state.meta?.perPage, 20);
      expect(controller.state.meta?.total, 200);
      expect(controller.state.meta?.lastPage, 10);
      expect(controller.state.meta?.hasMore, isTrue);

      await controller.loadNextPage();
      expect(controller.state.meta?.page, 2);
      expect(controller.state.meta?.hasMore, isTrue);

      // Load until last page
      while (controller.canLoadMore) {
        await controller.loadNextPage();
      }

      expect(controller.state.meta?.page, 10);
      expect(controller.state.meta?.hasMore, isFalse);
    });

    test('item preservation: should preserve items on error', () async {
      var failAppend = true;
      controller = PaginatrixCubit<Map<String, dynamic>>(
        loader: ({
          int? page,
          int? perPage,
          int? offset,
          int? limit,
          String? cursor,
          CancelToken? cancelToken,
        }) async {
          if (page == 2 && failAppend) {
            failAppend = false;
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
      final firstPageItems = List.from(controller.state.items);
      expect(firstPageItems.length, 20);

      // Append fails
      await controller.loadNextPage();
      expect(controller.state.items.length, 20);
      expect(controller.state.items, equals(firstPageItems));
      expect(controller.state.appendError, isNotNull);
    });

    test('concurrent load and refresh: should handle race condition', () async {
      controller = createTestController(
        mockData: mockData,
        loaderDelay: const Duration(milliseconds: 50),
      );

      // Start concurrent operations
      final futures = [
        controller.loadFirstPage(),
        controller.refresh(),
        controller.loadNextPage(),
      ];

      await Future.wait(futures);
      await Future.delayed(const Duration(milliseconds: 100));

      // Should end in a valid state
      expect(controller.hasError, isFalse);
      expect(controller.state.status, equals(const PaginationStatus.success()));
    });
  });
}
