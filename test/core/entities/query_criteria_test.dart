import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  group('QueryCriteria', () {
    test('empty factory creates criteria with no search, filters, or sorting', () {
      final criteria = QueryCriteria.empty();

      expect(criteria.searchTerm, isEmpty);
      expect(criteria.filters, isEmpty);
      expect(criteria.sortBy, isNull);
      expect(criteria.sortDesc, isFalse);
    });

    test('hasActiveFilters returns false for empty criteria', () {
      final criteria = QueryCriteria.empty();

      expect(criteria.hasActiveFilters, isFalse);
      expect(criteria.hasSearchTerm, isFalse);
      expect(criteria.hasFilters, isFalse);
      expect(criteria.hasSorting, isFalse);
    });

    test('hasActiveFilters returns true when search term is present', () {
      final criteria = QueryCriteria(searchTerm: 'test');

      expect(criteria.hasActiveFilters, isTrue);
      expect(criteria.hasSearchTerm, isTrue);
    });

    test('hasActiveFilters returns true when filters are present', () {
      final criteria = QueryCriteria(filters: {'status': 'active'});

      expect(criteria.hasActiveFilters, isTrue);
      expect(criteria.hasFilters, isTrue);
    });

    test('hasActiveFilters returns true when sorting is present', () {
      final criteria = QueryCriteria(sortBy: 'name');

      expect(criteria.hasActiveFilters, isTrue);
      expect(criteria.hasSorting, isTrue);
    });

    test('copyWith creates new instance with updated values', () {
      final original = QueryCriteria.empty();
      final updated = original.copyWith(searchTerm: 'test');

      expect(original.searchTerm, isEmpty);
      expect(updated.searchTerm, equals('test'));
    });

    test('withFilter adds or updates a filter', () {
      final criteria = QueryCriteria.empty();
      final withFilter = criteria.withFilter('status', 'active');

      expect(withFilter.filters['status'], equals('active'));
      expect(withFilter.filters.length, equals(1));
    });

    test('withFilter removes filter when value is null', () {
      final criteria = QueryCriteria(filters: {'status': 'active'});
      final withoutFilter = criteria.withFilter('status', null);

      expect(withoutFilter.filters.containsKey('status'), isFalse);
      expect(withoutFilter.filters, isEmpty);
    });

    test('withFilters updates multiple filters at once', () {
      final criteria = QueryCriteria.empty();
      final withFilters = criteria.withFilters({
        'status': 'active',
        'category': 'electronics',
      });

      expect(withFilters.filters['status'], equals('active'));
      expect(withFilters.filters['category'], equals('electronics'));
      expect(withFilters.filters.length, equals(2));
    });

    test('withFilters removes filters with null values', () {
      final criteria = QueryCriteria(filters: {
        'status': 'active',
        'category': 'electronics',
      });
      final updated = criteria.withFilters({
        'status': null,
        'category': 'books',
      });

      expect(updated.filters.containsKey('status'), isFalse);
      expect(updated.filters['category'], equals('books'));
      expect(updated.filters.length, equals(1));
    });

    test('removeFilter removes specific filter', () {
      final criteria = QueryCriteria(filters: {
        'status': 'active',
        'category': 'electronics',
      });
      final updated = criteria.removeFilter('status');

      expect(updated.filters.containsKey('status'), isFalse);
      expect(updated.filters['category'], equals('electronics'));
      expect(updated.filters.length, equals(1));
    });

    test('clearSearch removes search term', () {
      final criteria = QueryCriteria(searchTerm: 'test');
      final cleared = criteria.clearSearch();

      expect(cleared.searchTerm, isEmpty);
      expect(cleared.hasSearchTerm, isFalse);
    });

    test('clearFilters removes all filters', () {
      final criteria = QueryCriteria(filters: {
        'status': 'active',
        'category': 'electronics',
      });
      final cleared = criteria.clearFilters();

      expect(cleared.filters, isEmpty);
      expect(cleared.hasFilters, isFalse);
    });

    test('clearSorting removes sorting', () {
      final criteria = QueryCriteria(sortBy: 'name', sortDesc: true);
      final cleared = criteria.clearSorting();

      expect(cleared.sortBy, isNull);
      expect(cleared.sortDesc, isFalse);
      expect(cleared.hasSorting, isFalse);
    });

    test('clearAll removes all criteria', () {
      final criteria = QueryCriteria(
        searchTerm: 'test',
        filters: {'status': 'active'},
        sortBy: 'name',
        sortDesc: true,
      );
      final cleared = criteria.clearAll();

      expect(cleared.searchTerm, isEmpty);
      expect(cleared.filters, isEmpty);
      expect(cleared.sortBy, isNull);
      expect(cleared.sortDesc, isFalse);
      expect(cleared.hasActiveFilters, isFalse);
    });

    test('equality works correctly', () {
      final criteria1 = QueryCriteria(
        searchTerm: 'test',
        filters: {'status': 'active'},
        sortBy: 'name',
        sortDesc: false,
      );
      final criteria2 = QueryCriteria(
        searchTerm: 'test',
        filters: {'status': 'active'},
        sortBy: 'name',
        sortDesc: false,
      );
      final criteria3 = QueryCriteria(
        searchTerm: 'different',
        filters: {'status': 'active'},
        sortBy: 'name',
        sortDesc: false,
      );

      expect(criteria1, equals(criteria2));
      expect(criteria1, isNot(equals(criteria3)));
    });
  });
}


