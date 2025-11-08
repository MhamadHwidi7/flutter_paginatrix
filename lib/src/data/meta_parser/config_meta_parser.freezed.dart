// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_meta_parser.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MetaConfig _$MetaConfigFromJson(Map<String, dynamic> json) {
  return _MetaConfig.fromJson(json);
}

/// @nodoc
mixin _$MetaConfig {
  /// Path to items array (e.g., 'data.items', 'results')
  String get itemsPath => throw _privateConstructorUsedError;

  /// Path to current page (e.g., 'meta.current_page', 'page')
  String? get pagePath => throw _privateConstructorUsedError;

  /// Path to per page count (e.g., 'meta.per_page', 'limit')
  String? get perPagePath => throw _privateConstructorUsedError;

  /// Path to total count (e.g., 'meta.total', 'total')
  String? get totalPath => throw _privateConstructorUsedError;

  /// Path to last page (e.g., 'meta.last_page', 'total_pages')
  String? get lastPagePath => throw _privateConstructorUsedError;

  /// Path to has more flag (e.g., 'meta.has_more', 'has_next')
  String? get hasMorePath => throw _privateConstructorUsedError;

  /// Path to next cursor (e.g., 'meta.next_cursor', 'next')
  String? get nextCursorPath => throw _privateConstructorUsedError;

  /// Path to previous cursor (e.g., 'meta.previous_cursor', 'prev')
  String? get previousCursorPath => throw _privateConstructorUsedError;

  /// Path to offset (e.g., 'meta.offset', 'skip')
  String? get offsetPath => throw _privateConstructorUsedError;

  /// Path to limit (e.g., 'meta.limit', 'take')
  String? get limitPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetaConfigCopyWith<MetaConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaConfigCopyWith<$Res> {
  factory $MetaConfigCopyWith(
          MetaConfig value, $Res Function(MetaConfig) then) =
      _$MetaConfigCopyWithImpl<$Res, MetaConfig>;
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
class _$MetaConfigCopyWithImpl<$Res, $Val extends MetaConfig>
    implements $MetaConfigCopyWith<$Res> {
  _$MetaConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      itemsPath: null == itemsPath
          ? _value.itemsPath
          : itemsPath // ignore: cast_nullable_to_non_nullable
              as String,
      pagePath: freezed == pagePath
          ? _value.pagePath
          : pagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      perPagePath: freezed == perPagePath
          ? _value.perPagePath
          : perPagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPath: freezed == totalPath
          ? _value.totalPath
          : totalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPagePath: freezed == lastPagePath
          ? _value.lastPagePath
          : lastPagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMorePath: freezed == hasMorePath
          ? _value.hasMorePath
          : hasMorePath // ignore: cast_nullable_to_non_nullable
              as String?,
      nextCursorPath: freezed == nextCursorPath
          ? _value.nextCursorPath
          : nextCursorPath // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCursorPath: freezed == previousCursorPath
          ? _value.previousCursorPath
          : previousCursorPath // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetPath: freezed == offsetPath
          ? _value.offsetPath
          : offsetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      limitPath: freezed == limitPath
          ? _value.limitPath
          : limitPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetaConfigImplCopyWith<$Res>
    implements $MetaConfigCopyWith<$Res> {
  factory _$$MetaConfigImplCopyWith(
          _$MetaConfigImpl value, $Res Function(_$MetaConfigImpl) then) =
      __$$MetaConfigImplCopyWithImpl<$Res>;
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
class __$$MetaConfigImplCopyWithImpl<$Res>
    extends _$MetaConfigCopyWithImpl<$Res, _$MetaConfigImpl>
    implements _$$MetaConfigImplCopyWith<$Res> {
  __$$MetaConfigImplCopyWithImpl(
      _$MetaConfigImpl _value, $Res Function(_$MetaConfigImpl) _then)
      : super(_value, _then);

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
    return _then(_$MetaConfigImpl(
      itemsPath: null == itemsPath
          ? _value.itemsPath
          : itemsPath // ignore: cast_nullable_to_non_nullable
              as String,
      pagePath: freezed == pagePath
          ? _value.pagePath
          : pagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      perPagePath: freezed == perPagePath
          ? _value.perPagePath
          : perPagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPath: freezed == totalPath
          ? _value.totalPath
          : totalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPagePath: freezed == lastPagePath
          ? _value.lastPagePath
          : lastPagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMorePath: freezed == hasMorePath
          ? _value.hasMorePath
          : hasMorePath // ignore: cast_nullable_to_non_nullable
              as String?,
      nextCursorPath: freezed == nextCursorPath
          ? _value.nextCursorPath
          : nextCursorPath // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCursorPath: freezed == previousCursorPath
          ? _value.previousCursorPath
          : previousCursorPath // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetPath: freezed == offsetPath
          ? _value.offsetPath
          : offsetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      limitPath: freezed == limitPath
          ? _value.limitPath
          : limitPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaConfigImpl implements _MetaConfig {
  const _$MetaConfigImpl(
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

  factory _$MetaConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaConfigImplFromJson(json);

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

  @override
  String toString() {
    return 'MetaConfig(itemsPath: $itemsPath, pagePath: $pagePath, perPagePath: $perPagePath, totalPath: $totalPath, lastPagePath: $lastPagePath, hasMorePath: $hasMorePath, nextCursorPath: $nextCursorPath, previousCursorPath: $previousCursorPath, offsetPath: $offsetPath, limitPath: $limitPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaConfigImpl &&
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

  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaConfigImplCopyWith<_$MetaConfigImpl> get copyWith =>
      __$$MetaConfigImplCopyWithImpl<_$MetaConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaConfigImplToJson(
      this,
    );
  }
}

abstract class _MetaConfig implements MetaConfig {
  const factory _MetaConfig(
      {required final String itemsPath,
      final String? pagePath,
      final String? perPagePath,
      final String? totalPath,
      final String? lastPagePath,
      final String? hasMorePath,
      final String? nextCursorPath,
      final String? previousCursorPath,
      final String? offsetPath,
      final String? limitPath}) = _$MetaConfigImpl;

  factory _MetaConfig.fromJson(Map<String, dynamic> json) =
      _$MetaConfigImpl.fromJson;

  @override

  /// Path to items array (e.g., 'data.items', 'results')
  String get itemsPath;
  @override

  /// Path to current page (e.g., 'meta.current_page', 'page')
  String? get pagePath;
  @override

  /// Path to per page count (e.g., 'meta.per_page', 'limit')
  String? get perPagePath;
  @override

  /// Path to total count (e.g., 'meta.total', 'total')
  String? get totalPath;
  @override

  /// Path to last page (e.g., 'meta.last_page', 'total_pages')
  String? get lastPagePath;
  @override

  /// Path to has more flag (e.g., 'meta.has_more', 'has_next')
  String? get hasMorePath;
  @override

  /// Path to next cursor (e.g., 'meta.next_cursor', 'next')
  String? get nextCursorPath;
  @override

  /// Path to previous cursor (e.g., 'meta.previous_cursor', 'prev')
  String? get previousCursorPath;
  @override

  /// Path to offset (e.g., 'meta.offset', 'skip')
  String? get offsetPath;
  @override

  /// Path to limit (e.g., 'meta.limit', 'take')
  String? get limitPath;
  @override
  @JsonKey(ignore: true)
  _$$MetaConfigImplCopyWith<_$MetaConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
