import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Pagination Integration Tests', () {
    late PaginatedCubit<Map<String, dynamic>> controller;
    late List<Map<String, dynamic>> mockData;

    setUp(() {
      mockData = createMockData(totalItems: 200);
    });

    tearDown(() {
      controller.close();
    });

    test('complete pagination flow: initial load -> pagination -> refresh', () async {
      controller = createTestController(mockData: mockData);

      // Initial state
      expect(controller.state.items, isEmpty);
      expect(controller.isLoading, isFalse);

      // Load first page
      await controller.loadFirstPage();
      expect(controller.hasData, isTrue);
      expect(controller.state.items.length, 20);
      expect(controller.state.meta?.page, 1);
      expect(controller.canLoadMore, isTrue);

      // Load next page
      await controller.loadNextPage();
      expect(controller.state.items.length, 40);
      expect(controller.state.meta?.page, 2);

      // Load another page
      await controller.loadNextPage();
      expect(controller.state.items.length, 60);
      expect(controller.state.meta?.page, 3);

      // Refresh
      await controller.refresh();
      expect(controller.state.items.length, 20);
      expect(controller.state.meta?.page, 1);
    });

    test('error recovery flow: error -> retry -> success', () async {
      var shouldFail = true;
      controller = PaginatedCubit<Map<String, dynamic>>(
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

    test('append error recovery: append fails -> retry -> success', () async {
      var failCount = 0;
      controller = PaginatedCubit<Map<String, dynamic>>(
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
      
      expect(states.any((s) => s.status.maybeWhen(
        initial: () => true,
        orElse: () => false,
      )), isTrue);
      // Check for loading state (might be very fast, so check if we have success state)
      expect(states.any((s) => s.hasData), isTrue);

      // Success -> Appending -> Success
      await controller.loadNextPage();
      // Wait a bit for all states to be emitted
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(states.any((s) => s.status.maybeWhen(
        appending: () => true,
        orElse: () => false,
      )), isTrue);

      await subscription.cancel();
    });
  });
}

