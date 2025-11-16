import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  group('PaginatrixCubit - Search and Filtering', () {
    late PaginatrixCubit<Map<String, dynamic>> cubit;

    setUp(() {
      cubit = PaginatrixCubit<Map<String, dynamic>>(
        loader: ({
          int? page,
          int? perPage,
          int? offset,
          int? limit,
          String? cursor,
          CancelToken? cancelToken,
          QueryCriteria? query,
        }) async {
          return {
            'data': [
              {'id': 1, 'name': 'Item 1'},
              {'id': 2, 'name': 'Item 2'},
            ],
            'meta': {
              'current_page': page ?? 1,
              'per_page': perPage ?? 20,
              'total': 100,
              'last_page': 5,
            },
          };
        },
        itemDecoder: (json) => json,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
        options: PaginationOptions(
          searchDebounceDuration: Duration(milliseconds: 100),
        ),
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('updateSearchTerm updates query', () async {
      await cubit.loadFirstPage();
      expect(cubit.state.currentQuery.searchTerm, isEmpty);

      cubit.updateSearchTerm('test');
      expect(cubit.state.currentQuery.searchTerm, equals('test'));
    });

    test('updateFilter updates filter criteria', () async {
      await cubit.loadFirstPage();

      cubit.updateFilter('status', 'active');
      expect(cubit.state.currentQuery.filters['status'], equals('active'));
    });

    test('clearAllQuery clears all search, filters, and sorting', () async {
      await cubit.loadFirstPage();

      cubit.updateSearchTerm('test');
      cubit.updateFilter('status', 'active');
      cubit.updateSorting('name');

      cubit.clearAllQuery();

      expect(cubit.state.currentQuery.searchTerm, isEmpty);
      expect(cubit.state.currentQuery.filters, isEmpty);
      expect(cubit.state.currentQuery.sortBy, isNull);
    });
  });
}
