// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_criteria.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryCriteria {
  /// Search term for text-based searching
  String get searchTerm;

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

  /// Field name to sort by (null means no sorting)
  ///
  /// **Note:** Empty strings are treated as null (no sorting).
  /// Use null explicitly to indicate no sorting.
  String? get sortBy;

  /// Whether to sort in descending order (false = ascending)
  bool get sortDesc;

  /// Create a copy of QueryCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryCriteriaCopyWith<QueryCriteria> get copyWith =>
      _$QueryCriteriaCopyWithImpl<QueryCriteria>(
          this as QueryCriteria, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryCriteria &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm) &&
            const DeepCollectionEquality().equals(other.filters, filters) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortDesc, sortDesc) ||
                other.sortDesc == sortDesc));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchTerm,
      const DeepCollectionEquality().hash(filters), sortBy, sortDesc);

  @override
  String toString() {
    return 'QueryCriteria(searchTerm: $searchTerm, filters: $filters, sortBy: $sortBy, sortDesc: $sortDesc)';
  }
}

/// @nodoc
abstract mixin class $QueryCriteriaCopyWith<$Res> {
  factory $QueryCriteriaCopyWith(
          QueryCriteria value, $Res Function(QueryCriteria) _then) =
      _$QueryCriteriaCopyWithImpl;
  @useResult
  $Res call(
      {String searchTerm,
      Map<String, dynamic> filters,
      String? sortBy,
      bool sortDesc});
}

/// @nodoc
class _$QueryCriteriaCopyWithImpl<$Res>
    implements $QueryCriteriaCopyWith<$Res> {
  _$QueryCriteriaCopyWithImpl(this._self, this._then);

  final QueryCriteria _self;
  final $Res Function(QueryCriteria) _then;

  /// Create a copy of QueryCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchTerm = null,
    Object? filters = null,
    Object? sortBy = freezed,
    Object? sortDesc = null,
  }) {
    return _then(_self.copyWith(
      searchTerm: null == searchTerm
          ? _self.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _self.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sortBy: freezed == sortBy
          ? _self.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortDesc: null == sortDesc
          ? _self.sortDesc
          : sortDesc // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [QueryCriteria].
extension QueryCriteriaPatterns on QueryCriteria {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_QueryCriteria value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryCriteria() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_QueryCriteria value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryCriteria():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_QueryCriteria value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryCriteria() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String searchTerm, Map<String, dynamic> filters,
            String? sortBy, bool sortDesc)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryCriteria() when $default != null:
        return $default(
            _that.searchTerm, _that.filters, _that.sortBy, _that.sortDesc);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String searchTerm, Map<String, dynamic> filters,
            String? sortBy, bool sortDesc)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryCriteria():
        return $default(
            _that.searchTerm, _that.filters, _that.sortBy, _that.sortDesc);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String searchTerm, Map<String, dynamic> filters,
            String? sortBy, bool sortDesc)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryCriteria() when $default != null:
        return $default(
            _that.searchTerm, _that.filters, _that.sortBy, _that.sortDesc);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _QueryCriteria extends QueryCriteria {
  const _QueryCriteria(
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

  /// Create a copy of QueryCriteria
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QueryCriteriaCopyWith<_QueryCriteria> get copyWith =>
      __$QueryCriteriaCopyWithImpl<_QueryCriteria>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QueryCriteria &&
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

  @override
  String toString() {
    return 'QueryCriteria(searchTerm: $searchTerm, filters: $filters, sortBy: $sortBy, sortDesc: $sortDesc)';
  }
}

/// @nodoc
abstract mixin class _$QueryCriteriaCopyWith<$Res>
    implements $QueryCriteriaCopyWith<$Res> {
  factory _$QueryCriteriaCopyWith(
          _QueryCriteria value, $Res Function(_QueryCriteria) _then) =
      __$QueryCriteriaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String searchTerm,
      Map<String, dynamic> filters,
      String? sortBy,
      bool sortDesc});
}

/// @nodoc
class __$QueryCriteriaCopyWithImpl<$Res>
    implements _$QueryCriteriaCopyWith<$Res> {
  __$QueryCriteriaCopyWithImpl(this._self, this._then);

  final _QueryCriteria _self;
  final $Res Function(_QueryCriteria) _then;

  /// Create a copy of QueryCriteria
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? searchTerm = null,
    Object? filters = null,
    Object? sortBy = freezed,
    Object? sortDesc = null,
  }) {
    return _then(_QueryCriteria(
      searchTerm: null == searchTerm
          ? _self.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _self._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sortBy: freezed == sortBy
          ? _self.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortDesc: null == sortDesc
          ? _self.sortDesc
          : sortDesc // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
