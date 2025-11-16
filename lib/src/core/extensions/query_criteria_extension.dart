import 'package:flutter_paginatrix/src/core/entities/query_criteria.dart';

/// Extension methods for [QueryCriteria] to provide convenient helpers
///
/// **Note:** Methods that check for search, filters, or sorting are available
/// directly on [QueryCriteria] (e.g., [QueryCriteria.hasSearchTerm], 
/// [QueryCriteria.hasFilters], [QueryCriteria.hasSorting]). This extension
/// provides additional convenience methods and functional-style aliases.
///
/// ## Functional-Style Aliases
///
/// This extension provides `without*` methods as functional-style alternatives
/// to the primary `clear*` methods in [QueryCriteria]:
///
/// - [withoutSearch()] → [QueryCriteria.clearSearch()]
/// - [withoutFilter()] → [QueryCriteria.removeFilter()]
/// - [withoutSorting()] → [QueryCriteria.clearSorting()]
///
/// **Recommendation:** Prefer using the primary `clear*` methods in [QueryCriteria]
/// for consistency. The `without*` methods are provided for developers who prefer
/// functional-style APIs.
extension QueryCriteriaExtension on QueryCriteria {
  /// Whether the search term is not empty
  ///
  /// **Note:** This is an alias for [QueryCriteria.hasSearchTerm] for
  /// backward compatibility and functional-style API preference.
  /// Prefer using [QueryCriteria.hasSearchTerm] for consistency.
  @Deprecated('Use hasSearchTerm instead. This will be removed in a future version.')
  bool get hasSearch => hasSearchTerm;

  /// Gets the filter value for a given key, or null if not present
  dynamic getFilter(String key) => filters[key];

  /// Whether a specific filter is active
  bool hasFilter(String key) => filters.containsKey(key);

  /// Whether a specific filter has a given value
  bool hasFilterValue(String key, dynamic value) => filters[key] == value;

  /// Gets filter value with type safety
  ///
  /// Returns the filter value cast to type [T], or null if the filter
  /// doesn't exist or cannot be cast to [T].
  ///
  /// **Example:**
  /// ```dart
  /// final status = criteria.getFilterAs<String>('status');
  /// final count = criteria.getFilterAs<int>('count');
  /// ```
  T? getFilterAs<T>(String key) => filters[key] as T?;

  /// Creates a copy with the search term cleared
  ///
  /// **Note:** This is a functional-style alias for [QueryCriteria.clearSearch].
  /// Both methods produce the same result. Prefer using [QueryCriteria.clearSearch]
  /// for consistency with the primary API.
  QueryCriteria withoutSearch() => clearSearch();

  /// Creates a copy with a specific filter removed
  ///
  /// **Note:** This is a functional-style alias for [QueryCriteria.removeFilter].
  /// Both methods produce the same result. Prefer using [QueryCriteria.removeFilter]
  /// for consistency with the primary API.
  ///
  /// **Throws:** [ArgumentError] if [key] is empty
  QueryCriteria withoutFilter(String key) => removeFilter(key);

  /// Creates a copy with sorting cleared
  ///
  /// **Note:** This is a functional-style alias for [QueryCriteria.clearSorting].
  /// Both methods produce the same result. Prefer using [QueryCriteria.clearSorting]
  /// for consistency with the primary API.
  QueryCriteria withoutSorting() => clearSorting();
}

