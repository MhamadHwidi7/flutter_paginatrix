// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageMeta {
  /// Current page number (1-based)
  int? get page;

  /// Number of items per page
  int? get perPage;

  /// Total number of items
  int? get total;

  /// Total number of pages
  int? get lastPage;

  /// Whether there are more pages
  bool? get hasMore;

  /// Next cursor for cursor-based pagination
  String? get nextCursor;

  /// Previous cursor for cursor-based pagination
  String? get previousCursor;

  /// Offset for offset/limit pagination
  int? get offset;

  /// Limit for offset/limit pagination
  int? get limit;

  /// Create a copy of PageMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PageMetaCopyWith<PageMeta> get copyWith =>
      _$PageMetaCopyWithImpl<PageMeta>(this as PageMeta, _$identity);

  /// Serializes this PageMeta to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PageMeta &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.previousCursor, previousCursor) ||
                other.previousCursor == previousCursor) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, perPage, total, lastPage,
      hasMore, nextCursor, previousCursor, offset, limit);

  @override
  String toString() {
    return 'PageMeta(page: $page, perPage: $perPage, total: $total, lastPage: $lastPage, hasMore: $hasMore, nextCursor: $nextCursor, previousCursor: $previousCursor, offset: $offset, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class $PageMetaCopyWith<$Res> {
  factory $PageMetaCopyWith(PageMeta value, $Res Function(PageMeta) _then) =
      _$PageMetaCopyWithImpl;
  @useResult
  $Res call(
      {int? page,
      int? perPage,
      int? total,
      int? lastPage,
      bool? hasMore,
      String? nextCursor,
      String? previousCursor,
      int? offset,
      int? limit});
}

/// @nodoc
class _$PageMetaCopyWithImpl<$Res> implements $PageMetaCopyWith<$Res> {
  _$PageMetaCopyWithImpl(this._self, this._then);

  final PageMeta _self;
  final $Res Function(PageMeta) _then;

  /// Create a copy of PageMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = freezed,
    Object? perPage = freezed,
    Object? total = freezed,
    Object? lastPage = freezed,
    Object? hasMore = freezed,
    Object? nextCursor = freezed,
    Object? previousCursor = freezed,
    Object? offset = freezed,
    Object? limit = freezed,
  }) {
    return _then(_self.copyWith(
      page: freezed == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _self.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      lastPage: freezed == lastPage
          ? _self.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int?,
      hasMore: freezed == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool?,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCursor: freezed == previousCursor
          ? _self.previousCursor
          : previousCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      offset: freezed == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PageMeta].
extension PageMetaPatterns on PageMeta {
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
    TResult Function(_PageMeta value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PageMeta() when $default != null:
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
    TResult Function(_PageMeta value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageMeta():
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
    TResult? Function(_PageMeta value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageMeta() when $default != null:
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
    TResult Function(
            int? page,
            int? perPage,
            int? total,
            int? lastPage,
            bool? hasMore,
            String? nextCursor,
            String? previousCursor,
            int? offset,
            int? limit)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PageMeta() when $default != null:
        return $default(
            _that.page,
            _that.perPage,
            _that.total,
            _that.lastPage,
            _that.hasMore,
            _that.nextCursor,
            _that.previousCursor,
            _that.offset,
            _that.limit);
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
    TResult Function(
            int? page,
            int? perPage,
            int? total,
            int? lastPage,
            bool? hasMore,
            String? nextCursor,
            String? previousCursor,
            int? offset,
            int? limit)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageMeta():
        return $default(
            _that.page,
            _that.perPage,
            _that.total,
            _that.lastPage,
            _that.hasMore,
            _that.nextCursor,
            _that.previousCursor,
            _that.offset,
            _that.limit);
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
    TResult? Function(
            int? page,
            int? perPage,
            int? total,
            int? lastPage,
            bool? hasMore,
            String? nextCursor,
            String? previousCursor,
            int? offset,
            int? limit)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageMeta() when $default != null:
        return $default(
            _that.page,
            _that.perPage,
            _that.total,
            _that.lastPage,
            _that.hasMore,
            _that.nextCursor,
            _that.previousCursor,
            _that.offset,
            _that.limit);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PageMeta implements PageMeta {
  const _PageMeta(
      {this.page,
      this.perPage,
      this.total,
      this.lastPage,
      this.hasMore,
      this.nextCursor,
      this.previousCursor,
      this.offset,
      this.limit});
  factory _PageMeta.fromJson(Map<String, dynamic> json) =>
      _$PageMetaFromJson(json);

  /// Current page number (1-based)
  @override
  final int? page;

  /// Number of items per page
  @override
  final int? perPage;

  /// Total number of items
  @override
  final int? total;

  /// Total number of pages
  @override
  final int? lastPage;

  /// Whether there are more pages
  @override
  final bool? hasMore;

  /// Next cursor for cursor-based pagination
  @override
  final String? nextCursor;

  /// Previous cursor for cursor-based pagination
  @override
  final String? previousCursor;

  /// Offset for offset/limit pagination
  @override
  final int? offset;

  /// Limit for offset/limit pagination
  @override
  final int? limit;

  /// Create a copy of PageMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PageMetaCopyWith<_PageMeta> get copyWith =>
      __$PageMetaCopyWithImpl<_PageMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PageMetaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PageMeta &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.previousCursor, previousCursor) ||
                other.previousCursor == previousCursor) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, perPage, total, lastPage,
      hasMore, nextCursor, previousCursor, offset, limit);

  @override
  String toString() {
    return 'PageMeta(page: $page, perPage: $perPage, total: $total, lastPage: $lastPage, hasMore: $hasMore, nextCursor: $nextCursor, previousCursor: $previousCursor, offset: $offset, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class _$PageMetaCopyWith<$Res>
    implements $PageMetaCopyWith<$Res> {
  factory _$PageMetaCopyWith(_PageMeta value, $Res Function(_PageMeta) _then) =
      __$PageMetaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? page,
      int? perPage,
      int? total,
      int? lastPage,
      bool? hasMore,
      String? nextCursor,
      String? previousCursor,
      int? offset,
      int? limit});
}

/// @nodoc
class __$PageMetaCopyWithImpl<$Res> implements _$PageMetaCopyWith<$Res> {
  __$PageMetaCopyWithImpl(this._self, this._then);

  final _PageMeta _self;
  final $Res Function(_PageMeta) _then;

  /// Create a copy of PageMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? page = freezed,
    Object? perPage = freezed,
    Object? total = freezed,
    Object? lastPage = freezed,
    Object? hasMore = freezed,
    Object? nextCursor = freezed,
    Object? previousCursor = freezed,
    Object? offset = freezed,
    Object? limit = freezed,
  }) {
    return _then(_PageMeta(
      page: freezed == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _self.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      lastPage: freezed == lastPage
          ? _self.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int?,
      hasMore: freezed == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool?,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCursor: freezed == previousCursor
          ? _self.previousCursor
          : previousCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      offset: freezed == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
