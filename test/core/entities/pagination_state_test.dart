import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

void main() {
  group('PaginationState', () {
    test('initial state should have correct defaults', () {
      final state = PaginationState.initial();

      expect(state.status, isA<PaginationStatus>());
      expect(state.items, isEmpty);
      expect(state.meta, isNull);
      expect(state.error, isNull);
      expect(state.appendError, isNull);
      expect(state.requestContext, isNull);
      expect(state.isStale, isFalse);
      expect(state.lastLoadedAt, isNull);
    });

    test('loading state should preserve previous items', () {
      final previousItems = [1, 2, 3];
      final previousMeta = PageMeta.fromJson({
        'current_page': 1,
        'per_page': 20,
        'total': 100,
      });
      final requestContext = RequestContext.create(
        generation: 1,
        cancelToken: CancelToken(),
      );

      final state = PaginationState.loading(
        requestContext: requestContext,
        previousItems: previousItems,
        previousMeta: previousMeta,
      );

      expect(state.status, isA<PaginationStatus>());
      expect(state.items, equals(previousItems));
      expect(state.meta, equals(previousMeta));
      expect(state.requestContext, equals(requestContext));
    });

    test('success state should have items and meta', () {
      final items = [1, 2, 3, 4, 5];
      final meta = PageMeta.fromJson({
        'current_page': 1,
        'per_page': 20,
        'total': 100,
        'has_more': true,
      });
      final requestContext = RequestContext.create(
        generation: 1,
        cancelToken: CancelToken(),
      );

      final state = PaginationState.success(
        items: items,
        meta: meta,
        requestContext: requestContext,
      );

      expect(state.items, equals(items));
      expect(state.meta, equals(meta));
      expect(state.requestContext, equals(requestContext));
      expect(state.lastLoadedAt, isNotNull);
    });

    test('error state should have error and preserve items', () {
      final previousItems = [1, 2, 3];
      const error = PaginationError.network(message: 'Network error');
      final requestContext = RequestContext.create(
        generation: 1,
        cancelToken: CancelToken(),
      );

      final state = PaginationState.error(
        error: error,
        requestContext: requestContext,
        previousItems: previousItems,
      );

      expect(state.error, equals(error));
      expect(state.items, equals(previousItems));
      expect(state.requestContext, equals(requestContext));
    });

    test('empty state should have no items', () {
      final requestContext = RequestContext.create(
        generation: 1,
        cancelToken: CancelToken(),
      );

      final state = PaginationState.empty(requestContext: requestContext);

      expect(state.items, isEmpty);
      expect(state.requestContext, equals(requestContext));
    });

    test('refreshing state should preserve current items', () {
      final currentItems = [1, 2, 3];
      final currentMeta = PageMeta.fromJson({
        'current_page': 1,
        'per_page': 20,
        'total': 100,
      });
      final requestContext = RequestContext.create(
        generation: 1,
        cancelToken: CancelToken(),
      );

      final state = PaginationState.refreshing(
        requestContext: requestContext,
        currentItems: currentItems,
        currentMeta: currentMeta,
      );

      expect(state.items, equals(currentItems));
      expect(state.meta, equals(currentMeta));
      expect(state.requestContext, equals(requestContext));
    });

    test('appending state should preserve current items', () {
      final currentItems = [1, 2, 3];
      final currentMeta = PageMeta.fromJson({
        'current_page': 1,
        'per_page': 20,
        'total': 100,
      });
      final requestContext = RequestContext.create(
        generation: 1,
        cancelToken: CancelToken(),
      );

      final state = PaginationState.appending(
        requestContext: requestContext,
        currentItems: currentItems,
        currentMeta: currentMeta,
      );

      expect(state.items, equals(currentItems));
      expect(state.meta, equals(currentMeta));
      expect(state.requestContext, equals(requestContext));
    });

    test('appendError state should preserve items and have append error', () {
      final currentItems = [1, 2, 3];
      final currentMeta = PageMeta.fromJson({
        'current_page': 1,
        'per_page': 20,
        'total': 100,
      });
      const appendError = PaginationError.network(
        message: 'Failed to load next page',
      );
      final requestContext = RequestContext.create(
        generation: 1,
        cancelToken: CancelToken(),
      );

      final state = PaginationState.appendError(
        appendError: appendError,
        requestContext: requestContext,
        currentItems: currentItems,
        currentMeta: currentMeta,
      );

      expect(state.items, equals(currentItems));
      expect(state.appendError, equals(appendError));
      expect(state.requestContext, equals(requestContext));
    });

    group('convenience getters', () {
      test('hasData should return true when items exist', () {
        final state = PaginationState.success(
          items: [1, 2, 3],
          meta: PageMeta.fromJson({'current_page': 1}),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.hasData, isTrue);
      });

      test('hasData should return false when items are empty', () {
        final state = PaginationState.initial();
        expect(state.hasData, isFalse);
      });

      test('isLoading should return true for loading state', () {
        final state = PaginationState.loading(
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.isLoading, isTrue);
      });

      test('hasError should return true when error exists', () {
        final state = PaginationState.error(
          error: const PaginationError.network(message: 'Error'),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.hasError, isTrue);
      });

      test('canLoadMore should return true when hasMore is true', () {
        final state = PaginationState.success(
          items: [1, 2, 3],
          meta: const PageMeta(hasMore: true),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.canLoadMore, isTrue);
      });

      test('isAppending should return true for appending state', () {
        final state = PaginationState.appending(
          currentItems: [1, 2, 3],
          currentMeta: const PageMeta(hasMore: true),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.isAppending, isTrue);
      });

      test('isAppending should return false for non-appending state', () {
        final state = PaginationState.success(
          items: [1, 2, 3],
          meta: const PageMeta(hasMore: true),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.isAppending, isFalse);
      });

      test('shouldShowFooter should return true when appending with items', () {
        final state = PaginationState.appending(
          currentItems: [1, 2, 3],
          currentMeta: const PageMeta(hasMore: true),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.shouldShowFooter, isTrue);
      });

      test(
          'shouldShowFooter should return true when has append error with items',
          () {
        final state = PaginationState.success(
          items: [1, 2, 3],
          meta: const PageMeta(hasMore: true),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        ).copyWith(
          appendError: const PaginationError.network(message: 'Append failed'),
        );

        expect(state.shouldShowFooter, isTrue);
      });

      test(
          'shouldShowFooter should return true when no more data but has items',
          () {
        final state = PaginationState.success(
          items: [1, 2, 3],
          meta: const PageMeta(hasMore: false),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.shouldShowFooter, isTrue);
      });

      test(
          'shouldShowFooter should return false when no items and no more pages',
          () {
        final state = PaginationState.empty(
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.shouldShowFooter, isFalse);
      });

      test(
          'shouldShowFooter should return false when appending but no items and no more pages',
          () {
        final state = PaginationState.appending(
          currentItems: [],
          currentMeta: const PageMeta(hasMore: false),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.shouldShowFooter, isFalse);
      });

      test('canLoadMore should return false when hasMore is false', () {
        final state = PaginationState.success(
          items: [1, 2, 3],
          meta: const PageMeta(hasMore: false),
          requestContext: RequestContext.create(
            generation: 1,
            cancelToken: CancelToken(),
          ),
        );

        expect(state.canLoadMore, isFalse);
      });
    });
  });
}
