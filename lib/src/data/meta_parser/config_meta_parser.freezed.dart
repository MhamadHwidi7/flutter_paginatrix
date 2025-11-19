// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_meta_parser.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetaConfig {
  /// Path to items array (e.g., 'data.items', 'results')
  String get itemsPath;

  /// Path to current page (e.g., 'meta.current_page', 'page')
  String? get pagePath;

  /// Path to per page count (e.g., 'meta.per_page', 'limit')
  String? get perPagePath;

  /// Path to total count (e.g., 'meta.total', 'total')
  String? get totalPath;

  /// Path to last page (e.g., 'meta.last_page', 'total_pages')
  String? get lastPagePath;

  /// Path to has more flag (e.g., 'meta.has_more', 'has_next')
  String? get hasMorePath;

  /// Path to next cursor (e.g., 'meta.next_cursor', 'next')
  String? get nextCursorPath;

  /// Path to previous cursor (e.g., 'meta.previous_cursor', 'prev')
  String? get previousCursorPath;

  /// Path to offset (e.g., 'meta.offset', 'skip')
  String? get offsetPath;

  /// Path to limit (e.g., 'meta.limit', 'take')
  String? get limitPath;

  /// Create a copy of MetaConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MetaConfigCopyWith<MetaConfig> get copyWith =>
      _$MetaConfigCopyWithImpl<MetaConfig>(this as MetaConfig, _$identity);

  /// Serializes this MetaConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MetaConfig &&
            (identical(other.itemsPath, itemsPath) ||
                other.itemsPath == itemsPath) &&
            (identical(other.pagePath, pagePath) ||
                other.pagePath == pagePath) &&
            (identical(other.perPagePath, perPagePath) ||
                other.perPagePath == perPagePath) &&
            (identical(other.totalPath, totalPath) ||
                other.totalPath == totalPath) &&
            (identical(other.lastPagePath, lastPagePath) ||
                other.lastPagePath == lastPagePath) &&
            (identical(other.hasMorePath, hasMorePath) ||
                other.hasMorePath == hasMorePath) &&
            (identical(other.nextCursorPath, nextCursorPath) ||
                other.nextCursorPath == nextCursorPath) &&
            (identical(other.previousCursorPath, previousCursorPath) ||
                other.previousCursorPath == previousCursorPath) &&
            (identical(other.offsetPath, offsetPath) ||
                other.offsetPath == offsetPath) &&
            (identical(other.limitPath, limitPath) ||
                other.limitPath == limitPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemsPath,
      pagePath,
      perPagePath,
      totalPath,
      lastPagePath,
      hasMorePath,
      nextCursorPath,
      previousCursorPath,
      offsetPath,
      limitPath);

  @override
  String toString() {
    return 'MetaConfig(itemsPath: $itemsPath, pagePath: $pagePath, perPagePath: $perPagePath, totalPath: $totalPath, lastPagePath: $lastPagePath, hasMorePath: $hasMorePath, nextCursorPath: $nextCursorPath, previousCursorPath: $previousCursorPath, offsetPath: $offsetPath, limitPath: $limitPath)';
  }
}

/// @nodoc
abstract mixin class $MetaConfigCopyWith<$Res> {
  factory $MetaConfigCopyWith(
          MetaConfig value, $Res Function(MetaConfig) _then) =
      _$MetaConfigCopyWithImpl;
  @useResult
  $Res call(
      {String itemsPath,
      String? pagePath,
      String? perPagePath,
      String? totalPath,
      String? lastPagePath,
      String? hasMorePath,
      String? nextCursorPath,
      String? previousCursorPath,
      String? offsetPath,
      String? limitPath});
}

/// @nodoc
class _$MetaConfigCopyWithImpl<$Res> implements $MetaConfigCopyWith<$Res> {
  _$MetaConfigCopyWithImpl(this._self, this._then);

  final MetaConfig _self;
  final $Res Function(MetaConfig) _then;

  /// Create a copy of MetaConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsPath = null,
    Object? pagePath = freezed,
    Object? perPagePath = freezed,
    Object? totalPath = freezed,
    Object? lastPagePath = freezed,
    Object? hasMorePath = freezed,
    Object? nextCursorPath = freezed,
    Object? previousCursorPath = freezed,
    Object? offsetPath = freezed,
    Object? limitPath = freezed,
  }) {
    return _then(_self.copyWith(
      itemsPath: null == itemsPath
          ? _self.itemsPath
          : itemsPath // ignore: cast_nullable_to_non_nullable
              as String,
      pagePath: freezed == pagePath
          ? _self.pagePath
          : pagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      perPagePath: freezed == perPagePath
          ? _self.perPagePath
          : perPagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPath: freezed == totalPath
          ? _self.totalPath
          : totalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPagePath: freezed == lastPagePath
          ? _self.lastPagePath
          : lastPagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMorePath: freezed == hasMorePath
          ? _self.hasMorePath
          : hasMorePath // ignore: cast_nullable_to_non_nullable
              as String?,
      nextCursorPath: freezed == nextCursorPath
          ? _self.nextCursorPath
          : nextCursorPath // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCursorPath: freezed == previousCursorPath
          ? _self.previousCursorPath
          : previousCursorPath // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetPath: freezed == offsetPath
          ? _self.offsetPath
          : offsetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      limitPath: freezed == limitPath
          ? _self.limitPath
          : limitPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MetaConfig].
extension MetaConfigPatterns on MetaConfig {
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
    TResult Function(_MetaConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MetaConfig() when $default != null:
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
    TResult Function(_MetaConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MetaConfig():
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
    TResult? Function(_MetaConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MetaConfig() when $default != null:
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
            String itemsPath,
            String? pagePath,
            String? perPagePath,
            String? totalPath,
            String? lastPagePath,
            String? hasMorePath,
            String? nextCursorPath,
            String? previousCursorPath,
            String? offsetPath,
            String? limitPath)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MetaConfig() when $default != null:
        return $default(
            _that.itemsPath,
            _that.pagePath,
            _that.perPagePath,
            _that.totalPath,
            _that.lastPagePath,
            _that.hasMorePath,
            _that.nextCursorPath,
            _that.previousCursorPath,
            _that.offsetPath,
            _that.limitPath);
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
            String itemsPath,
            String? pagePath,
            String? perPagePath,
            String? totalPath,
            String? lastPagePath,
            String? hasMorePath,
            String? nextCursorPath,
            String? previousCursorPath,
            String? offsetPath,
            String? limitPath)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MetaConfig():
        return $default(
            _that.itemsPath,
            _that.pagePath,
            _that.perPagePath,
            _that.totalPath,
            _that.lastPagePath,
            _that.hasMorePath,
            _that.nextCursorPath,
            _that.previousCursorPath,
            _that.offsetPath,
            _that.limitPath);
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
            String itemsPath,
            String? pagePath,
            String? perPagePath,
            String? totalPath,
            String? lastPagePath,
            String? hasMorePath,
            String? nextCursorPath,
            String? previousCursorPath,
            String? offsetPath,
            String? limitPath)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MetaConfig() when $default != null:
        return $default(
            _that.itemsPath,
            _that.pagePath,
            _that.perPagePath,
            _that.totalPath,
            _that.lastPagePath,
            _that.hasMorePath,
            _that.nextCursorPath,
            _that.previousCursorPath,
            _that.offsetPath,
            _that.limitPath);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MetaConfig implements MetaConfig {
  const _MetaConfig(
      {required this.itemsPath,
      this.pagePath,
      this.perPagePath,
      this.totalPath,
      this.lastPagePath,
      this.hasMorePath,
      this.nextCursorPath,
      this.previousCursorPath,
      this.offsetPath,
      this.limitPath});
  factory _MetaConfig.fromJson(Map<String, dynamic> json) =>
      _$MetaConfigFromJson(json);

  /// Path to items array (e.g., 'data.items', 'results')
  @override
  final String itemsPath;

  /// Path to current page (e.g., 'meta.current_page', 'page')
  @override
  final String? pagePath;

  /// Path to per page count (e.g., 'meta.per_page', 'limit')
  @override
  final String? perPagePath;

  /// Path to total count (e.g., 'meta.total', 'total')
  @override
  final String? totalPath;

  /// Path to last page (e.g., 'meta.last_page', 'total_pages')
  @override
  final String? lastPagePath;

  /// Path to has more flag (e.g., 'meta.has_more', 'has_next')
  @override
  final String? hasMorePath;

  /// Path to next cursor (e.g., 'meta.next_cursor', 'next')
  @override
  final String? nextCursorPath;

  /// Path to previous cursor (e.g., 'meta.previous_cursor', 'prev')
  @override
  final String? previousCursorPath;

  /// Path to offset (e.g., 'meta.offset', 'skip')
  @override
  final String? offsetPath;

  /// Path to limit (e.g., 'meta.limit', 'take')
  @override
  final String? limitPath;

  /// Create a copy of MetaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MetaConfigCopyWith<_MetaConfig> get copyWith =>
      __$MetaConfigCopyWithImpl<_MetaConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MetaConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MetaConfig &&
            (identical(other.itemsPath, itemsPath) ||
                other.itemsPath == itemsPath) &&
            (identical(other.pagePath, pagePath) ||
                other.pagePath == pagePath) &&
            (identical(other.perPagePath, perPagePath) ||
                other.perPagePath == perPagePath) &&
            (identical(other.totalPath, totalPath) ||
                other.totalPath == totalPath) &&
            (identical(other.lastPagePath, lastPagePath) ||
                other.lastPagePath == lastPagePath) &&
            (identical(other.hasMorePath, hasMorePath) ||
                other.hasMorePath == hasMorePath) &&
            (identical(other.nextCursorPath, nextCursorPath) ||
                other.nextCursorPath == nextCursorPath) &&
            (identical(other.previousCursorPath, previousCursorPath) ||
                other.previousCursorPath == previousCursorPath) &&
            (identical(other.offsetPath, offsetPath) ||
                other.offsetPath == offsetPath) &&
            (identical(other.limitPath, limitPath) ||
                other.limitPath == limitPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemsPath,
      pagePath,
      perPagePath,
      totalPath,
      lastPagePath,
      hasMorePath,
      nextCursorPath,
      previousCursorPath,
      offsetPath,
      limitPath);

  @override
  String toString() {
    return 'MetaConfig(itemsPath: $itemsPath, pagePath: $pagePath, perPagePath: $perPagePath, totalPath: $totalPath, lastPagePath: $lastPagePath, hasMorePath: $hasMorePath, nextCursorPath: $nextCursorPath, previousCursorPath: $previousCursorPath, offsetPath: $offsetPath, limitPath: $limitPath)';
  }
}

/// @nodoc
abstract mixin class _$MetaConfigCopyWith<$Res>
    implements $MetaConfigCopyWith<$Res> {
  factory _$MetaConfigCopyWith(
          _MetaConfig value, $Res Function(_MetaConfig) _then) =
      __$MetaConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String itemsPath,
      String? pagePath,
      String? perPagePath,
      String? totalPath,
      String? lastPagePath,
      String? hasMorePath,
      String? nextCursorPath,
      String? previousCursorPath,
      String? offsetPath,
      String? limitPath});
}

/// @nodoc
class __$MetaConfigCopyWithImpl<$Res> implements _$MetaConfigCopyWith<$Res> {
  __$MetaConfigCopyWithImpl(this._self, this._then);

  final _MetaConfig _self;
  final $Res Function(_MetaConfig) _then;

  /// Create a copy of MetaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? itemsPath = null,
    Object? pagePath = freezed,
    Object? perPagePath = freezed,
    Object? totalPath = freezed,
    Object? lastPagePath = freezed,
    Object? hasMorePath = freezed,
    Object? nextCursorPath = freezed,
    Object? previousCursorPath = freezed,
    Object? offsetPath = freezed,
    Object? limitPath = freezed,
  }) {
    return _then(_MetaConfig(
      itemsPath: null == itemsPath
          ? _self.itemsPath
          : itemsPath // ignore: cast_nullable_to_non_nullable
              as String,
      pagePath: freezed == pagePath
          ? _self.pagePath
          : pagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      perPagePath: freezed == perPagePath
          ? _self.perPagePath
          : perPagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPath: freezed == totalPath
          ? _self.totalPath
          : totalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPagePath: freezed == lastPagePath
          ? _self.lastPagePath
          : lastPagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMorePath: freezed == hasMorePath
          ? _self.hasMorePath
          : hasMorePath // ignore: cast_nullable_to_non_nullable
              as String?,
      nextCursorPath: freezed == nextCursorPath
          ? _self.nextCursorPath
          : nextCursorPath // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCursorPath: freezed == previousCursorPath
          ? _self.previousCursorPath
          : previousCursorPath // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetPath: freezed == offsetPath
          ? _self.offsetPath
          : offsetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      limitPath: freezed == limitPath
          ? _self.limitPath
          : limitPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
