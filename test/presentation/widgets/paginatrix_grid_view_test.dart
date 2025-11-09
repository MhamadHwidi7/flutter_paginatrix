import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('PaginatrixGridView Widget Tests', () {
    late PaginatedCubit<Map<String, dynamic>> cubit;
    late List<Map<String, dynamic>> mockData;

    setUp(() {
      mockData = createMockData(totalItems: 100);
      cubit = createTestController(mockData: mockData);
    });

    tearDown(() {
      cubit.close();
    });

    Widget createTestWidget({
      Widget Function(BuildContext, Map<String, dynamic>, int)? itemBuilder,
      SliverGridDelegate? gridDelegate,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PaginatrixGridView<Map<String, dynamic>>(
            cubit: cubit,
            gridDelegate: gridDelegate ??
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
            itemBuilder: itemBuilder ??
                (context, item, index) => Card(
                      child: Center(
                        child: Text(item['name'] ?? 'Item $index'),
                      ),
                    ),
          ),
        ),
      );
    }

    testWidgets('should display loading skeleton on initial state', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Should show skeleton loader
      expect(find.byType(PaginationSkeletonizer), findsOneWidget);
    });

    testWidgets('should display items in grid after successful load', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Load data
      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should show items in grid
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 20'), findsOneWidget);
    });

    testWidgets('should support custom grid delegate', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
        ),
      );

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('should display empty view when no items', (tester) async {
      final emptyCubit = createTestController<Map<String, dynamic>>(mockData: []);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixGridView<Map<String, dynamic>>(
              cubit: emptyCubit,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, item, index) => Card(
                child: Text(item['name'] ?? 'Item'),
              ),
            ),
          ),
        ),
      );

      await emptyCubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should show empty view
      expect(find.byType(GenericEmptyView), findsOneWidget);
      emptyCubit.close();
    });

    testWidgets('should display error view on error state', (tester) async {
      final errorCubit = PaginatedCubit<Map<String, dynamic>>(
        loader: createFailingLoader(),
        itemDecoder: (json) => json,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixGridView<Map<String, dynamic>>(
              cubit: errorCubit,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, item, index) => Card(
                child: Text(item['name'] ?? 'Item'),
              ),
            ),
          ),
        ),
      );

      await errorCubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should show error view
      expect(find.byType(PaginationErrorView), findsOneWidget);
      errorCubit.close();
    });

    testWidgets('should display append loader when loading more', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Trigger load next page
      cubit.loadNextPage();
      await tester.pump();

      // Should show append loader
      expect(find.byType(AppendLoader), findsOneWidget);
    });

    testWidgets('should handle pagination on scroll', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Scroll to near end
      final gridView = find.byType(CustomScrollView);
      await tester.drag(gridView, const Offset(0, -500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Should trigger load more
      await tester.pumpAndSettle();
      expect(cubit.state.items.length, greaterThan(20));
    });

    testWidgets('should support different cross axis counts', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
        ),
      );

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should render with 3 columns
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('should support spacing configuration', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
        ),
      );

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.text('Item 1'), findsOneWidget);
    });
  });
}

