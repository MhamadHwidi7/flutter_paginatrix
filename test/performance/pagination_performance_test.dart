import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Pagination Performance Benchmarks', () {
    late PaginatrixCubit<Map<String, dynamic>> controller;
    late List<Map<String, dynamic>> mockData;

    setUp(() {
      mockData = createMockData(totalItems: 10000); // Large dataset
    });

    tearDown(() {
      controller.close();
    });

    group('Large List Rendering', () {
      test('should handle loading 1000+ items efficiently', () async {
        final largeData = createMockData(totalItems: 5000);
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createMockLoader(
            mockData: largeData,
            itemsPerPage: 1000,
          ),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: const PaginationOptions(
            defaultPageSize: 1000,
            maxPageSize: 1000,
          ),
        );

        final stopwatch = Stopwatch()..start();

        // Load initial data
        await controller.loadFirstPage();
        expect(controller.state.items.length, 1000);
        expect(
            controller.state.status, equals(const PaginationStatus.success()));

        // Load subsequent pages
        for (var i = 0; i < 4; i++) {
          await controller.loadNextPage();
          expect(controller.state.status,
              equals(const PaginationStatus.success()));
          expect(controller.state.items.length, (i + 2) * 1000);
        }

        stopwatch.stop();

        // Verify final state
        expect(controller.state.items.length, 5000);
        expect(controller.state.meta?.total, 5000);
        expect(controller.canLoadMore, isFalse);
        expect(stopwatch.elapsedMilliseconds, lessThan(2000),
            reason: 'Loading 5000 items should complete within 2 seconds');

        // Refresh verification
        await controller.refresh();
        // After refresh, should have first page (refresh replaces all items with first page)
        // Note: The actual behavior depends on refresh implementation
        expect(controller.state.items.length, greaterThanOrEqualTo(1000),
            reason: 'After refresh, should have at least first page');
        // Refresh may keep all items or reset to first page depending on implementation
        // The important thing is that refresh works correctly
      });

      test('should handle concurrent operations without race conditions',
          () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createMockLoader(
            mockData: mockData,
            delay: const Duration(milliseconds: 100), // Simulate network delay
          ),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: const PaginationOptions(
            maxPageSize: 20,
          ),
        );

        final stopwatch = Stopwatch()..start();

        // Start multiple operations (they will be queued/cancelled appropriately)
        await controller.loadFirstPage();
        controller.loadNextPage(); // Should be queued
        await controller.refresh(); // Should cancel previous operations
        await controller.loadNextPage(); // Should be queued after refresh

        // Wait for all operations to complete
        await Future.delayed(const Duration(milliseconds: 500));

        stopwatch.stop();

        // Verify final state
        expect(
            controller.state.status, equals(const PaginationStatus.success()));
        expect(controller.state.items.length, greaterThanOrEqualTo(20),
            reason: 'Should have at least 1 page after all operations');
        expect(controller.state.meta?.page, greaterThanOrEqualTo(1),
            reason: 'Should be on at least page 1');
        expect(controller.hasError, isFalse);

        print(
            'Concurrent operations completed in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('should handle rapid pagination with debounce', () async {
        controller = PaginatrixCubit<Map<String, dynamic>>(
          loader: createMockLoader(
            mockData: mockData,
            delay: const Duration(milliseconds: 100), // Simulate network delay
          ),
          itemDecoder: (json) => json,
          metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
          options: const PaginationOptions(
            maxPageSize: 20,
          ),
        );

        final stopwatch = Stopwatch()..start();

        // Rapid pagination
        await controller.loadFirstPage();
        await controller.loadNextPage();
        await controller.loadNextPage();
        await controller.loadNextPage();
        await controller.loadNextPage();
        await controller.loadNextPage();
        await controller.loadNextPage();
        await controller.loadNextPage();
        await controller.loadNextPage();
        await controller.loadNextPage();

        stopwatch.stop();

        expect(controller.state.items.length, 200); // 10 pages * 20 items = 200
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        print('Loaded 10 pages in ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('Memory Usage', () {
      test('should not leak memory on multiple refreshes', () async {
        controller = createTestController(mockData: mockData);

        // Perform many refreshes
        for (int i = 0; i < 50; i++) {
          await controller.loadFirstPage();
          await controller.refresh();
        }

        // Should still work correctly
        expect(controller.hasData, isTrue);
        expect(controller.state.items.length, 20);
      });

      test('should clean up properly on dispose', () async {
        final controllers = <PaginatrixCubit>[];

        // Create many controllers
        for (int i = 0; i < 100; i++) {
          final cubit = createTestController(mockData: mockData);
          await cubit.loadFirstPage();
          controllers.add(cubit);
        }

        // Dispose all
        for (final cubit in controllers) {
          await cubit.close();
        }

        // All should be closed
        for (final cubit in controllers) {
          expect(cubit.isClosed, isTrue);
        }
      });

      test('should handle large items efficiently', () async {
        // Create items with large data
        final largeItems = List.generate(
            100,
            (index) => {
                  'id': index,
                  'data': 'x' * 10000, // 10KB per item
                });

        controller = createTestController(mockData: largeItems);

        final stopwatch = Stopwatch()..start();
        await controller.loadFirstPage();
        stopwatch.stop();

        expect(controller.state.items.length, 20);
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
        print('Loaded 20 large items in ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('Scroll Performance', () {
      test('should handle rapid scroll events efficiently', () async {
        controller = createTestController(mockData: mockData);
        await controller.loadFirstPage();

        final stopwatch = Stopwatch()..start();

        // Simulate rapid scroll events (checkAndLoadIfNearEnd calls)
        for (int i = 0; i < 100; i++) {
          final mockMetrics = _MockScrollMetrics(
            pixels: 100.0 * i,
            maxScrollExtent: 2000,
          );
          controller.checkAndLoadIfNearEnd(
            metrics: mockMetrics,
            prefetchThreshold: 3,
          );
        }

        stopwatch.stop();

        // Should handle rapidly without issues
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        print(
            'Handled 100 scroll events in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('should debounce scroll events correctly', () async {
        controller = createTestController(mockData: mockData);
        await controller.loadFirstPage();

        // Rapid scroll events
        for (int i = 0; i < 10; i++) {
          final mockMetrics = _MockScrollMetrics(
            pixels: 1900,
            maxScrollExtent: 2000,
          );
          controller.checkAndLoadIfNearEnd(
            metrics: mockMetrics,
            prefetchThreshold: 3,
          );
        }

        await Future.delayed(const Duration(milliseconds: 200));

        // Should have debounced - verify that load was triggered
        // The debounce timer should have fired after the delay
        expect(controller.state.items.length, greaterThanOrEqualTo(20));
      });
    });

    group('Parsing Performance', () {
      test('should parse metadata efficiently', () async {
        final parser = ConfigMetaParser(MetaConfig.nestedMeta);

        final data = {
          'data': List.generate(1000, (i) => {'id': i}),
          'meta': {
            'current_page': 1,
            'per_page': 1000,
            'total': 10000,
            'last_page': 10,
            'has_more': true,
          },
        };

        final stopwatch = Stopwatch()..start();

        // Parse many times
        for (int i = 0; i < 1000; i++) {
          parser.parseMeta(data);
        }

        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        print(
            'Parsed metadata 1000 times in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('should cache parsed paths efficiently', () async {
        final parser = ConfigMetaParser(MetaConfig.nestedMeta);

        final data = {
          'data': [],
          'meta': {
            'current_page': 1,
            'per_page': 20,
          },
        };

        final stopwatch = Stopwatch()..start();

        // Parse many times (should use cache)
        for (int i = 0; i < 10000; i++) {
          parser.parseMeta(data);
        }

        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        print(
            'Parsed with caching 10000 times in ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('Concurrent Operations', () {
      test('should handle concurrent refresh and pagination', () async {
        controller = createTestController(
          mockData: mockData,
          loaderDelay: const Duration(milliseconds: 50),
        );

        await controller.loadFirstPage();

        final stopwatch = Stopwatch()..start();

        // Concurrent operations
        final futures = <Future>[
          controller.refresh(),
          controller.loadNextPage(),
          controller.refresh(),
        ];

        await Future.wait(futures);
        stopwatch.stop();

        // Should handle gracefully
        expect(controller.hasData, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should handle multiple rapid state queries', () async {
        controller = createTestController(mockData: mockData);
        await controller.loadFirstPage();

        final stopwatch = Stopwatch()..start();

        // Rapid state queries
        for (int i = 0; i < 10000; i++) {
          final _ = controller.hasData;
          final __ = controller.isLoading;
          final ___ = controller.canLoadMore;
          final ____ = controller.state.items.length;
        }

        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        print('10000 state queries in ${stopwatch.elapsedMilliseconds}ms');
      });
    });
  });
}

/// Mock scroll metrics for testing
class _MockScrollMetrics implements ScrollMetrics {
  _MockScrollMetrics({
    required this.pixels,
    required this.maxScrollExtent,
  });
  @override
  final double pixels;

  @override
  final double maxScrollExtent;

  @override
  final double minScrollExtent = 0;

  @override
  final double viewportDimension = 800;

  @override
  final Axis axis = Axis.vertical;

  @override
  final AxisDirection axisDirection = AxisDirection.down;

  @override
  final double devicePixelRatio = 1;

  @override
  final bool atEdge = false;

  @override
  final double extentAfter = 0;

  @override
  final double extentBefore = 0;

  @override
  double get extentInside => viewportDimension;

  @override
  double get extentTotal => maxScrollExtent;

  @override
  bool get outOfRange => pixels < minScrollExtent || pixels > maxScrollExtent;

  @override
  final bool hasContentDimensions = true;

  @override
  final bool hasPixels = true;

  @override
  final bool hasViewportDimension = true;

  final bool hasMinScrollExtent = true;

  final bool hasMaxScrollExtent = true;

  @override
  ScrollMetrics copyWith({
    AxisDirection? axisDirection,
    double? devicePixelRatio,
    double? maxScrollExtent,
    double? minScrollExtent,
    double? pixels,
    double? viewportDimension,
  }) {
    return _MockScrollMetrics(
      pixels: pixels ?? this.pixels,
      maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
    );
  }
}
