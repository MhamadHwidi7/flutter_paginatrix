// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PageMeta _$PageMetaFromJson(Map<String, dynamic> json) {
  return _PageMeta.fromJson(json);
}

/// @nodoc
mixin _$PageMeta {
  /// Current page number (1-based)
  int? get page => throw _privateConstructorUsedError;

  /// Number of items per page
  int? get perPage => throw _privateConstructorUsedError;

  /// Total number of items
  int? get total => throw _privateConstructorUsedError;

  /// Total number of pages
  int? get lastPage => throw _privateConstructorUsedError;

  /// Whether there are more pages
  bool? get hasMore => throw _privateConstructorUsedError;

  /// Next cursor for cursor-based pagination
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Previous cursor for cursor-based pagination
  String? get previousCursor => throw _privateConstructorUsedError;

  /// Offset for offset/limit pagination
  int? get offset => throw _privateConstructorUsedError;

  /// Limit for offset/limit pagination
  int? get limit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PageMetaCopyWith<PageMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageMetaCopyWith<$Res> {
  factory $PageMetaCopyWith(PageMeta value, $Res Function(PageMeta) then) =
      _$PageMetaCopyWithImpl<$Res, PageMeta>;
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
class _$PageMetaCopyWithImpl<$Res, $Val extends PageMeta>
    implements $PageMetaCopyWith<$Res> {
  _$PageMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      lastPage: freezed == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int?,
      hasMore: freezed == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool?,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCursor: freezed == previousCursor
          ? _value.previousCursor
          : previousCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageMetaImplCopyWith<$Res>
    implements $PageMetaCopyWith<$Res> {
  factory _$$PageMetaImplCopyWith(
          _$PageMetaImpl value, $Res Function(_$PageMetaImpl) then) =
      __$$PageMetaImplCopyWithImpl<$Res>;
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
class __$$PageMetaImplCopyWithImpl<$Res>
    extends _$PageMetaCopyWithImpl<$Res, _$PageMetaImpl>
    implements _$$PageMetaImplCopyWith<$Res> {
  __$$PageMetaImplCopyWithImpl(
      _$PageMetaImpl _value, $Res Function(_$PageMetaImpl) _then)
      : super(_value, _then);

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
    return _then(_$PageMetaImpl(
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      lastPage: freezed == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int?,
      hasMore: freezed == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool?,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCursor: freezed == previousCursor
          ? _value.previousCursor
          : previousCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PageMetaImpl implements _PageMeta {
  const _$PageMetaImpl(
      {this.page,
      this.perPage,
      this.total,
      this.lastPage,
      this.hasMore,
      this.nextCursor,
      this.previousCursor,
      this.offset,
      this.limit});

  factory _$PageMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageMetaImplFromJson(json);

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

  @override
  String toString() {
    return 'PageMeta(page: $page, perPage: $perPage, total: $total, lastPage: $lastPage, hasMore: $hasMore, nextCursor: $nextCursor, previousCursor: $previousCursor, offset: $offset, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageMetaImpl &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, page, perPage, total, lastPage,
      hasMore, nextCursor, previousCursor, offset, limit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PageMetaImplCopyWith<_$PageMetaImpl> get copyWith =>
      __$$PageMetaImplCopyWithImpl<_$PageMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageMetaImplToJson(
      this,
    );
  }
}

abstract class _PageMeta implements PageMeta {
  const factory _PageMeta(
      {final int? page,
      final int? perPage,
      final int? total,
      final int? lastPage,
      final bool? hasMore,
      final String? nextCursor,
      final String? previousCursor,
      final int? offset,
      final int? limit}) = _$PageMetaImpl;

  factory _PageMeta.fromJson(Map<String, dynamic> json) =
      _$PageMetaImpl.fromJson;

  @override

  /// Current page number (1-based)
  int? get page;
  @override

  /// Number of items per page
  int? get perPage;
  @override

  /// Total number of items
  int? get total;
  @override

  /// Total number of pages
  int? get lastPage;
  @override

  /// Whether there are more pages
  bool? get hasMore;
  @override

  /// Next cursor for cursor-based pagination
  String? get nextCursor;
  @override

  /// Previous cursor for cursor-based pagination
  String? get previousCursor;
  @override

  /// Offset for offset/limit pagination
  int? get offset;
  @override

  /// Limit for offset/limit pagination
  int? get limit;
  @override
  @JsonKey(ignore: true)
  _$$PageMetaImplCopyWith<_$PageMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
