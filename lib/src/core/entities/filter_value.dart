import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_value.freezed.dart';

/// Sealed class representing a type-safe filter value
///
/// This class provides type safety for filter values while maintaining
/// flexibility. Use this when you need compile-time type checking for filters.
///
/// ## Usage
///
/// ```dart
/// // Create typed filter values
/// final statusFilter = FilterValue.string('active');
/// final countFilter = FilterValue.integer(42);
/// final enabledFilter = FilterValue.boolean(value: true);
/// final priceFilter = FilterValue.double(99.99);
/// final tagsFilter = FilterValue.list(['tag1', 'tag2']);
///
/// // Use in QueryCriteria
/// final criteria = QueryCriteria().withFilter('status', statusFilter);
///
/// // Extract values with pattern matching
/// final value = criteria.getFilter('status');
/// if (value is FilterValue) {
///   value.when(
///     string: (v) => print('String: $v'),
///     integer: (v) => print('Int: $v'),
///     boolean: (v) => print('Bool: $v'),
///     double: (v) => print('Double: $v'),
///     list: (v) => print('List: $v'),
///   );
/// }
/// ```
@freezed
sealed class FilterValue with _$FilterValue {
  /// String filter value
  ///
  /// Use for text-based filters like status, category, name, etc.
  ///
  /// **Example:**
  /// ```dart
  /// FilterValue.string('active')
  /// FilterValue.string('electronics')
  /// ```
  const factory FilterValue.string(String value) = StringFilterValue;

  /// Integer filter value
  ///
  /// Use for numeric filters like count, age, quantity, etc.
  ///
  /// **Example:**
  /// ```dart
  /// FilterValue.integer(42)
  /// FilterValue.integer(100)
  /// ```
  const factory FilterValue.integer(int value) = IntegerFilterValue;

  /// Boolean filter value
  ///
  /// Use for true/false filters like enabled, active, verified, etc.
  ///
  /// **Example:**
  /// ```dart
  /// FilterValue.boolean(value: true)
  /// FilterValue.boolean(value: false)
  /// ```
  const factory FilterValue.boolean({required bool value}) = BooleanFilterValue;

  /// Double filter value
  ///
  /// Use for decimal numeric filters like price, rating, percentage, etc.
  ///
  /// **Example:**
  /// ```dart
  /// FilterValue.double(99.99)
  /// FilterValue.double(4.5)
  /// ```
  const factory FilterValue.double(double value) = DoubleFilterValue;

  /// List filter value
  ///
  /// Use for array-based filters like tags, categories, IDs, etc.
  ///
  /// **Example:**
  /// ```dart
  /// FilterValue.list(['tag1', 'tag2', 'tag3'])
  /// FilterValue.list([1, 2, 3])
  /// ```
  const factory FilterValue.list(List<dynamic> value) = ListFilterValue;
}

/// Extension methods for FilterValue
extension FilterValueExtension on FilterValue {
  /// Converts the filter value to its dynamic representation
  ///
  /// This is useful when you need to pass the value to APIs that expect
  /// dynamic values, or when serializing to JSON.
  ///
  /// **Example:**
  /// ```dart
  /// final filter = FilterValue.string('active');
  /// final dynamicValue = filter.toDynamic(); // 'active'
  /// ```
  dynamic toDynamic() {
    return when(
      string: (value) => value,
      integer: (value) => value,
      boolean: (value) => value,
      double: (value) => value,
      list: (value) => value,
    );
  }

  /// Gets the value as a specific type, or null if not compatible
  ///
  /// **Example:**
  /// ```dart
  /// final filter = FilterValue.integer(42);
  /// final intValue = filter.as<int>(); // 42
  /// final stringValue = filter.as<String>(); // null
  /// ```
  T? as<T>() {
    final dynamicValue = toDynamic();
    if (dynamicValue is T) {
      return dynamicValue;
    }
    return null;
  }
}
