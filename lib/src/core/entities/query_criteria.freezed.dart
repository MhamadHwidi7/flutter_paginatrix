// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_criteria.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QueryCriteria {
  /// Search term for text-based searching
  String get searchTerm => throw _privateConstructorUsedError;

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
  Map<String, dynamic> get filters => throw _privateConstructorUsedError;

  /// Field name to sort by (null means no sorting)
  ///
  /// **Note:** Empty strings are treated as null (no sorting).
  /// Use null explicitly to indicate no sorting.
  String? get sortBy => throw _privateConstructorUsedError;

  /// Whether to sort in descending order (false = ascending)
  bool get sortDesc => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QueryCriteriaCopyWith<QueryCriteria> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryCriteriaCopyWith<$Res> {
  factory $QueryCriteriaCopyWith(
          QueryCriteria value, $Res Function(QueryCriteria) then) =
      _$QueryCriteriaCopyWithImpl<$Res, QueryCriteria>;
  @useResult
  $Res call(
      {String searchTerm,
      Map<String, dynamic> filters,
      String? sortBy,
      bool sortDesc});
}

/// @nodoc
class _$QueryCriteriaCopyWithImpl<$Res, $Val extends QueryCriteria>
    implements $QueryCriteriaCopyWith<$Res> {
  _$QueryCriteriaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchTerm = null,
    Object? filters = null,
    Object? sortBy = freezed,
    Object? sortDesc = null,
  }) {
    return _then(_value.copyWith(
      searchTerm: null == searchTerm
          ? _value.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortDesc: null == sortDesc
          ? _value.sortDesc
          : sortDesc // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryCriteriaImplCopyWith<$Res>
    implements $QueryCriteriaCopyWith<$Res> {
  factory _$$QueryCriteriaImplCopyWith(
          _$QueryCriteriaImpl value, $Res Function(_$QueryCriteriaImpl) then) =
      __$$QueryCriteriaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String searchTerm,
      Map<String, dynamic> filters,
      String? sortBy,
      bool sortDesc});
}

/// @nodoc
class __$$QueryCriteriaImplCopyWithImpl<$Res>
    extends _$QueryCriteriaCopyWithImpl<$Res, _$QueryCriteriaImpl>
    implements _$$QueryCriteriaImplCopyWith<$Res> {
  __$$QueryCriteriaImplCopyWithImpl(
      _$QueryCriteriaImpl _value, $Res Function(_$QueryCriteriaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchTerm = null,
    Object? filters = null,
    Object? sortBy = freezed,
    Object? sortDesc = null,
  }) {
    return _then(_$QueryCriteriaImpl(
      searchTerm: null == searchTerm
          ? _value.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortDesc: null == sortDesc
          ? _value.sortDesc
          : sortDesc // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$QueryCriteriaImpl extends _QueryCriteria {
  const _$QueryCriteriaImpl(
      {this.searchTerm = '',
      final Map<String, dynamic> filters = const {},
      this.sortBy,
      this.sortDesc = false})
      : _filters = filters,
        super._();

  /// Search term for text-based searching
  @override
  @JsonKey()
  final String searchTerm;

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
  final Map<String, dynamic> _filters;

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
  @override
  @JsonKey()
  Map<String, dynamic> get filters {
    if (_filters is EqualUnmodifiableMapView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_filters);
  }

  /// Field name to sort by (null means no sorting)
  ///
  /// **Note:** Empty strings are treated as null (no sorting).
  /// Use null explicitly to indicate no sorting.
  @override
  final String? sortBy;

  /// Whether to sort in descending order (false = ascending)
  @override
  @JsonKey()
  final bool sortDesc;

  @override
  String toString() {
    return 'QueryCriteria(searchTerm: $searchTerm, filters: $filters, sortBy: $sortBy, sortDesc: $sortDesc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryCriteriaImpl &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm) &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortDesc, sortDesc) ||
                other.sortDesc == sortDesc));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchTerm,
      const DeepCollectionEquality().hash(_filters), sortBy, sortDesc);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryCriteriaImplCopyWith<_$QueryCriteriaImpl> get copyWith =>
      __$$QueryCriteriaImplCopyWithImpl<_$QueryCriteriaImpl>(this, _$identity);
}

abstract class _QueryCriteria extends QueryCriteria {
  const factory _QueryCriteria(
      {final String searchTerm,
      final Map<String, dynamic> filters,
      final String? sortBy,
      final bool sortDesc}) = _$QueryCriteriaImpl;
  const _QueryCriteria._() : super._();

  @override

  /// Search term for text-based searching
  String get searchTerm;
  @override

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
  Map<String, dynamic> get filters;
  @override

  /// Field name to sort by (null means no sorting)
  ///
  /// **Note:** Empty strings are treated as null (no sorting).
  /// Use null explicitly to indicate no sorting.
  String? get sortBy;
  @override

  /// Whether to sort in descending order (false = ascending)
  bool get sortDesc;
  @override
  @JsonKey(ignore: true)
  _$$QueryCriteriaImplCopyWith<_$QueryCriteriaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
