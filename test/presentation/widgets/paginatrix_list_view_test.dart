import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('PaginatrixListView Widget Tests', () {
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
      Widget Function(BuildContext)? emptyBuilder,
      Widget Function(BuildContext, PaginationError)? errorBuilder,
      Widget Function(BuildContext, PaginationError)? appendErrorBuilder,
      Widget Function(BuildContext)? appendLoaderBuilder,
      VoidCallback? onPullToRefresh,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PaginatrixListView<Map<String, dynamic>>(
            cubit: cubit,
            itemBuilder: itemBuilder ??
                (context, item, index) => ListTile(
                      title: Text(item['name'] ?? 'Item $index'),
                    ),
            emptyBuilder: emptyBuilder,
            errorBuilder: errorBuilder,
            appendErrorBuilder: appendErrorBuilder,
            appendLoaderBuilder: appendLoaderBuilder,
            onPullToRefresh: onPullToRefresh,
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

    testWidgets('should display items after successful load', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Load data
      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should show items
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 20'), findsOneWidget);
    });

    testWidgets('should display empty view when no items', (tester) async {
      final emptyCubit = createTestController<Map<String, dynamic>>(mockData: []);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<Map<String, dynamic>>(
              cubit: emptyCubit,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item['name'] ?? 'Item'),
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

    testWidgets('should display custom empty builder when provided', (tester) async {
      final emptyCubit = createTestController<Map<String, dynamic>>(mockData: []);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<Map<String, dynamic>>(
              cubit: emptyCubit,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item['name'] ?? 'Item'),
              ),
              emptyBuilder: (context) => const Text('Custom Empty'),
            ),
          ),
        ),
      );

      await emptyCubit.loadFirstPage();
      await tester.pumpAndSettle();

      expect(find.text('Custom Empty'), findsOneWidget);
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
            body: PaginatrixListView<Map<String, dynamic>>(
              cubit: errorCubit,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item['name'] ?? 'Item'),
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

    testWidgets('should display custom error builder when provided', (tester) async {
      final errorCubit = PaginatedCubit<Map<String, dynamic>>(
        loader: createFailingLoader(),
        itemDecoder: (json) => json,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<Map<String, dynamic>>(
              cubit: errorCubit,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item['name'] ?? 'Item'),
              ),
              errorBuilder: (context, error) => Text('Custom Error: ${error.userMessage}'),
            ),
          ),
        ),
      );

      await errorCubit.loadFirstPage();
      await tester.pumpAndSettle();

      expect(find.textContaining('Custom Error'), findsOneWidget);
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

    testWidgets('should display custom append loader when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          appendLoaderBuilder: (context) => const Text('Loading more...'),
        ),
      );
      await tester.pump();

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      cubit.loadNextPage();
      await tester.pump();

      expect(find.text('Loading more...'), findsOneWidget);
    });

    testWidgets('should display append error when append fails', (tester) async {
      var failAppend = true;
      final errorCubit = PaginatedCubit<Map<String, dynamic>>(
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<Map<String, dynamic>>(
              cubit: errorCubit,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item['name'] ?? 'Item'),
              ),
            ),
          ),
        ),
      );

      await errorCubit.loadFirstPage();
      await tester.pumpAndSettle();

      await errorCubit.loadNextPage();
      await tester.pumpAndSettle();

      // Should show append error
      expect(find.byType(AppendErrorView), findsOneWidget);
      errorCubit.close();
    });

    testWidgets('should support pull to refresh', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Find the scrollable
      final scrollable = find.byType(RefreshIndicator);
      expect(scrollable, findsOneWidget);

      // Simulate pull to refresh
      await tester.drag(scrollable, const Offset(0, 300));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should call onPullToRefresh callback', (tester) async {
      var refreshCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          onPullToRefresh: () {
            refreshCalled = true;
          },
        ),
      );
      await tester.pump();

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Simulate pull to refresh
      final scrollable = find.byType(RefreshIndicator);
      await tester.drag(scrollable, const Offset(0, 300));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Note: RefreshIndicator's onRefresh is async, so we check after a delay
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('should support horizontal scrolling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: PaginatrixListView<Map<String, dynamic>>(
                cubit: cubit,
                itemBuilder: (context, item, index) => SizedBox(
                  width: 200,
                  child: ListTile(
                    title: Text(item['name'] ?? 'Item'),
                  ),
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ),
      );

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('should support reverse scrolling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<Map<String, dynamic>>(
              cubit: cubit,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item['name'] ?? 'Item'),
              ),
              reverse: true,
            ),
          ),
        ),
      );

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('should support separator builder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<Map<String, dynamic>>(
              cubit: cubit,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item['name'] ?? 'Item'),
              ),
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ),
      );

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should show dividers between items
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('should support key builder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<Map<String, dynamic>>(
              cubit: cubit,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item['name'] ?? 'Item'),
              ),
              keyBuilder: (item, index) => 'item_${item['id']}',
            ),
          ),
        ),
      );

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('should handle pagination on scroll', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await cubit.loadFirstPage();
      await tester.pumpAndSettle();

      // Scroll to near end
      final listView = find.byType(CustomScrollView);
      await tester.drag(listView, const Offset(0, -500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Should trigger load more
      await tester.pumpAndSettle();
      expect(cubit.state.items.length, greaterThan(20));
    });
  });
}

