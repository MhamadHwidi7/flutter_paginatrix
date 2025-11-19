import 'package:freezed_annotation/freezed_annotation.dart';

part 'query_criteria.freezed.dart';

/// Immutable value object representing search and filter criteria for pagination
///
/// This class encapsulates all query-related parameters (search term, filters, sorting)
/// in a single, immutable value object that can be safely passed around and compared.
///
/// ## Basic Usage
///
/// ```dart
/// // Create initial criteria
/// final criteria = QueryCriteria();
///
/// // Update search term
/// final withSearch = criteria.copyWith(searchTerm: 'john');
///
/// // Add filter
/// final withFilter = withSearch.copyWith(
///   filters: {'status': 'active', 'role': 'admin'},
/// );
///
/// // Add sorting
/// final withSort = withFilter.copyWith(
///   sortBy: 'name',
///   sortDesc: false,
/// );
///
/// // Check if has active filters
/// if (withSort.hasActiveFilters) {
///   // Apply filters
/// }
/// ```
///
/// ## Filter Value Types
///
/// Filters support various value types. Here are examples for each type:
///
/// ### String Filters
/// ```dart
/// final criteria = QueryCriteria().withFilter('status', 'active');
/// final category = QueryCriteria().withFilter('category', 'electronics');
/// ```
///
/// ### Integer Filters
/// ```dart
/// final criteria = QueryCriteria().withFilter('age', 25);
/// final count = QueryCriteria().withFilter('quantity', 100);
/// ```
///
/// ### Boolean Filters
/// ```dart
/// final criteria = QueryCriteria().withFilter('enabled', true);
/// final verified = QueryCriteria().withFilter('isVerified', false);
/// ```
///
/// ### Double Filters
/// ```dart
/// final criteria = QueryCriteria().withFilter('price', 99.99);
/// final rating = QueryCriteria().withFilter('rating', 4.5);
/// ```
///
/// ### List Filters
/// ```dart
/// final criteria = QueryCriteria().withFilter('tags', ['tag1', 'tag2']);
/// final ids = QueryCriteria().withFilter('categoryIds', [1, 2, 3]);
/// ```
///
/// ### Multiple Filters
/// ```dart
/// final criteria = QueryCriteria().withFilters({
///   'status': 'active',        // String
///   'age': 25,                  // int
///   'enabled': true,            // bool
///   'price': 99.99,            // double
///   'tags': ['tag1', 'tag2'],   // List
/// });
/// ```
///
/// ## Method Naming: `clear*` vs `without*`
///
/// This class provides two sets of methods for clearing criteria:
///
/// ### `clear*` Methods (Primary API)
/// - [clearSearch()] - Clears the search term
/// - [clearFilters()] - Clears all filters
/// - [clearSorting()] - Clears sorting
/// - [clearAll()] - Clears everything
///
/// These are the **primary methods** and should be preferred for consistency.
///
/// ### `without*` Methods (Functional-style Aliases)
/// - `QueryCriteriaExtension.withoutSearch()` - Alias for `clearSearch()`
/// - `QueryCriteriaExtension.withoutFilter()` - Alias for `removeFilter()`
/// - `QueryCriteriaExtension.withoutSorting()` - Alias for `clearSorting()`
///
/// These are provided in `QueryCriteriaExtension` for developers who prefer
/// functional-style APIs. They delegate to the primary `clear*` methods.
///
/// **Recommendation:** Use `clear*` methods for consistency with the primary API.
///
/// ## Best Practices for Repositories
///
/// When using `QueryCriteria` in repository patterns:
///
/// ### 1. Type-Safe Filter Access
/// ```dart
/// // Use getFilterAs for type-safe access
/// final status = criteria.getFilterAs<String>('status');
/// final count = criteria.getFilterAs<int>('count');
/// if (status != null) {
///   // Use status safely
/// }
/// ```
///
/// ### 2. Validate Filter Keys
/// ```dart
/// // Always validate filter keys before use
/// if (criteria.hasFilter('status')) {
///   final status = criteria.getFilterAs<String>('status');
///   // Process status
/// }
/// ```
///
/// ### 3. Build Query Parameters
/// ```dart
/// Map<String, dynamic> buildQueryParams(QueryCriteria criteria) {
///   final params = <String, dynamic>{};
///
///   // Add search
///   if (criteria.hasSearchTerm) {
///     params['q'] = criteria.searchTerm;
///   }
///
///   // Add filters
///   criteria.filters.forEach((key, value) {
///     params[key] = value;
///   });
///
///   // Add sorting
///   if (criteria.hasSorting) {
///     params['sort'] = criteria.sortBy;
///     params['order'] = criteria.sortDesc ? 'desc' : 'asc';
///   }
///
///   return params;
/// }
/// ```
///
/// ### 4. Handle Empty Criteria
/// ```dart
/// if (criteria.isEmpty) {
///   // Load all items without filters
///   return loadAll();
/// }
/// ```
///
/// ### 5. Immutable Updates
/// ```dart
/// // Always create new instances (immutability)
/// final updated = criteria.withFilter('status', 'active');
/// // criteria remains unchanged
/// ```
///
/// ## Migration Guide
///
/// If you're updating from an older version that used different method names:
///
/// - `withoutSearch()` → Use `clearSearch()` (or keep `withoutSearch()` as alias)
/// - `withoutFilter(key)` → Use `removeFilter(key)` (or keep `withoutFilter()` as alias)
/// - `withoutSorting()` → Use `clearSorting()` (or keep `withoutSorting()` as alias)
///
/// The old methods are still available as aliases but are deprecated.
@freezed
abstract class QueryCriteria with _$QueryCriteria {
  const factory QueryCriteria({
    /// Search term for text-based searching
    @Default('') String searchTerm,

    /// Map of filter key-value pairs
    ///
    /// Keys represent filter names, values represent filter values.
    /// Supports various value types: String, int, bool, double, List, etc.
    ///
    /// **Examples:**
    /// ```dart
    /// // String filter
    /// filters: {'status': 'active'}
    ///
    /// // Integer filter
    /// filters: {'age': 25}
    ///
    /// // Boolean filter
    /// filters: {'enabled': true}
    ///
    /// // Double filter
    /// filters: {'price': 99.99}
    ///
    /// // List filter
    /// filters: {'tags': ['tag1', 'tag2']}
    ///
    /// // Multiple filters
    /// filters: {
    ///   'status': 'active',
    ///   'category': 'electronics',
    ///   'minPrice': 10.0,
    ///   'maxPrice': 100.0,
    /// }
    /// ```
    ///
    /// **Note:** For type-safe filter values, consider using `FilterValue`
    /// sealed class. You can still use dynamic values for flexibility.
    @Default({}) Map<String, dynamic> filters,

    /// Field name to sort by (null means no sorting)
    ///
    /// **Note:** Empty strings are treated as null (no sorting).
    /// Use null explicitly to indicate no sorting.
    String? sortBy,

    /// Whether to sort in descending order (false = ascending)
    @Default(false) bool sortDesc,
  }) = _QueryCriteria;

  const QueryCriteria._();

  /// Creates an empty query criteria with no search, filters, or sorting
  factory QueryCriteria.empty() => const QueryCriteria();

  /// Whether this query has any active filters, search term, or sorting
  ///
  /// Returns true if:
  /// - Search term is not empty, OR
  /// - Filters map is not empty, OR
  /// - Sort field is specified
  bool get hasActiveFilters {
    return searchTerm.isNotEmpty || filters.isNotEmpty || sortBy != null;
  }

  /// Whether the search term is empty
  bool get hasSearchTerm => searchTerm.isNotEmpty;

  /// Whether any filters are applied
  bool get hasFilters => filters.isNotEmpty;

  /// Whether sorting is applied
  bool get hasSorting => sortBy != null;

  /// Creates a copy with cleared search term
  ///
  /// This is the primary method for clearing search. For a functional-style
  /// alternative, see `QueryCriteriaExtension.withoutSearch()`.
  QueryCriteria clearSearch() {
    return copyWith(searchTerm: '');
  }

  /// Creates a copy with cleared filters
  ///
  /// This is the primary method for clearing all filters. Individual filters
  /// can be removed using [removeFilter] or by setting a filter value to null
  /// in [withFilter].
  QueryCriteria clearFilters() {
    return copyWith(filters: const {});
  }

  /// Creates a copy with cleared sorting
  ///
  /// This is the primary method for clearing sorting. For a functional-style
  /// alternative, see `QueryCriteriaExtension.withoutSorting()`.
  QueryCriteria clearSorting() {
    return copyWith(sortBy: null, sortDesc: false);
  }

  /// Creates a copy with all criteria cleared
  QueryCriteria clearAll() {
    return const QueryCriteria();
  }

  /// Whether this query is completely empty (no search, filters, or sorting)
  ///
  /// Returns true if:
  /// - Search term is empty, AND
  /// - Filters map is empty, AND
  /// - Sort field is null
  bool get isEmpty {
    return searchTerm.isEmpty && filters.isEmpty && sortBy == null;
  }

  /// Creates a copy with a specific filter added or updated
  ///
  /// If [value] is null, the filter is removed.
  ///
  /// **Throws:** [ArgumentError] if [key] is empty or contains only whitespace
  QueryCriteria withFilter(String key, dynamic value) {
    // Validate key is not empty
    if (key.isEmpty) {
      throw ArgumentError.value(
        key,
        'key',
        'Filter key cannot be empty',
      );
    }

    // Validate key is not whitespace-only
    if (key.trim().isEmpty) {
      throw ArgumentError.value(
        key,
        'key',
        'Filter key cannot be whitespace-only',
      );
    }

    final newFilters = Map<String, dynamic>.from(filters);
    if (value == null) {
      newFilters.remove(key);
    } else {
      newFilters[key] = value;
    }
    return copyWith(filters: newFilters);
  }

  /// Creates a copy with multiple filters added or updated
  ///
  /// Filters with null values are removed.
  ///
  /// **Throws:** [ArgumentError] if any key in [newFilters] is empty or whitespace-only
  QueryCriteria withFilters(Map<String, dynamic> newFilters) {
    // Validate all keys
    for (final key in newFilters.keys) {
      if (key.isEmpty) {
        throw ArgumentError.value(
          key,
          'newFilters',
          'Filter key cannot be empty',
        );
      }
      if (key.trim().isEmpty) {
        throw ArgumentError.value(
          key,
          'newFilters',
          'Filter key cannot be whitespace-only',
        );
      }
    }

    final updatedFilters = Map<String, dynamic>.from(filters);
    newFilters.forEach((key, value) {
      if (value == null) {
        updatedFilters.remove(key);
      } else {
        updatedFilters[key] = value;
      }
    });
    return copyWith(filters: updatedFilters);
  }

  /// Creates a copy with a specific filter removed
  ///
  /// **Throws:** [ArgumentError] if [key] is empty
  QueryCriteria removeFilter(String key) {
    if (key.isEmpty) {
      throw ArgumentError.value(
        key,
        'key',
        'Filter key cannot be empty',
      );
    }

    final newFilters = Map<String, dynamic>.from(filters);
    newFilters.remove(key);
    return copyWith(filters: newFilters);
  }

  /// Creates a copy with only search term (clears filters and sorting)
  ///
  /// Useful when you want to reset filters and sorting but keep the search term.
  ///
  /// **Example:**
  /// ```dart
  /// final criteria = QueryCriteria(
  ///   searchTerm: 'john',
  ///   filters: {'status': 'active'},
  ///   sortBy: 'name',
  /// );
  /// final searchOnly = criteria.withSearchOnly('john');
  /// // searchOnly has only searchTerm, filters and sorting are cleared
  /// ```
  QueryCriteria withSearchOnly(String term) {
    return QueryCriteria(searchTerm: term.trim());
  }

  /// Creates a copy with only filters (clears search and sorting)
  ///
  /// Useful when you want to reset search and sorting but keep the filters.
  ///
  /// **Example:**
  /// ```dart
  /// final criteria = QueryCriteria(
  ///   searchTerm: 'john',
  ///   filters: {'status': 'active'},
  ///   sortBy: 'name',
  /// );
  /// final filtersOnly = criteria.withFiltersOnly({'status': 'active'});
  /// // filtersOnly has only filters, search and sorting are cleared
  /// ```
  QueryCriteria withFiltersOnly(Map<String, dynamic> newFilters) {
    // Validate all keys
    for (final key in newFilters.keys) {
      if (key.isEmpty) {
        throw ArgumentError.value(
          key,
          'newFilters',
          'Filter key cannot be empty',
        );
      }
    }
    return QueryCriteria(filters: Map<String, dynamic>.from(newFilters));
  }

  /// Creates a copy with only sorting (clears search and filters)
  ///
  /// Useful when you want to reset search and filters but keep the sorting.
  ///
  /// **Example:**
  /// ```dart
  /// final criteria = QueryCriteria(
  ///   searchTerm: 'john',
  ///   filters: {'status': 'active'},
  ///   sortBy: 'name',
  /// );
  /// final sortingOnly = criteria.withSortingOnly('name', sortDesc: false);
  /// // sortingOnly has only sorting, search and filters are cleared
  /// ```
  QueryCriteria withSortingOnly(String sortBy, {bool sortDesc = false}) {
    if (sortBy.isEmpty) {
      throw ArgumentError.value(
        sortBy,
        'sortBy',
        'Sort field cannot be empty',
      );
    }
    return QueryCriteria(sortBy: sortBy, sortDesc: sortDesc);
  }
}
