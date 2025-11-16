// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaginationState<T> {
  /// Current pagination status
  PaginationStatus get status => throw _privateConstructorUsedError;

  /// List of loaded items
  List<T> get items => throw _privateConstructorUsedError;

  /// Current pagination metadata
  PageMeta? get meta => throw _privateConstructorUsedError;

  /// Current error (if any)
  PaginationError? get error => throw _privateConstructorUsedError;

  /// Append error (non-blocking)
  PaginationError? get appendError => throw _privateConstructorUsedError;

  /// Current request context
  RequestContext? get requestContext => throw _privateConstructorUsedError;

  /// Whether data is stale and needs refresh
  bool get isStale => throw _privateConstructorUsedError;

  /// Last successful load timestamp
  DateTime? get lastLoadedAt => throw _privateConstructorUsedError;

  /// Current search and filter criteria
  /// Defaults to empty criteria (no search, filters, or sorting)
  QueryCriteria? get query => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PaginationStateCopyWith<T, PaginationState<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationStateCopyWith<T, $Res> {
  factory $PaginationStateCopyWith(
          PaginationState<T> value, $Res Function(PaginationState<T>) then) =
      _$PaginationStateCopyWithImpl<T, $Res, PaginationState<T>>;
  @useResult
  $Res call(
      {PaginationStatus status,
      List<T> items,
      PageMeta? meta,
      PaginationError? error,
      PaginationError? appendError,
      RequestContext? requestContext,
      bool isStale,
      DateTime? lastLoadedAt,
      QueryCriteria? query});

  $PaginationStatusCopyWith<$Res> get status;
  $PageMetaCopyWith<$Res>? get meta;
  $PaginationErrorCopyWith<$Res>? get error;
  $PaginationErrorCopyWith<$Res>? get appendError;
  $RequestContextCopyWith<$Res>? get requestContext;
  $QueryCriteriaCopyWith<$Res>? get query;
}

/// @nodoc
class _$PaginationStateCopyWithImpl<T, $Res, $Val extends PaginationState<T>>
    implements $PaginationStateCopyWith<T, $Res> {
  _$PaginationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? items = null,
    Object? meta = freezed,
    Object? error = freezed,
    Object? appendError = freezed,
    Object? requestContext = freezed,
    Object? isStale = null,
    Object? lastLoadedAt = freezed,
    Object? query = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaginationStatus,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PageMeta?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as PaginationError?,
      appendError: freezed == appendError
          ? _value.appendError
          : appendError // ignore: cast_nullable_to_non_nullable
              as PaginationError?,
      requestContext: freezed == requestContext
          ? _value.requestContext
          : requestContext // ignore: cast_nullable_to_non_nullable
              as RequestContext?,
      isStale: null == isStale
          ? _value.isStale
          : isStale // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoadedAt: freezed == lastLoadedAt
          ? _value.lastLoadedAt
          : lastLoadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as QueryCriteria?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationStatusCopyWith<$Res> get status {
    return $PaginationStatusCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PageMetaCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $PageMetaCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationErrorCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $PaginationErrorCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationErrorCopyWith<$Res>? get appendError {
    if (_value.appendError == null) {
      return null;
    }

    return $PaginationErrorCopyWith<$Res>(_value.appendError!, (value) {
      return _then(_value.copyWith(appendError: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RequestContextCopyWith<$Res>? get requestContext {
    if (_value.requestContext == null) {
      return null;
    }

    return $RequestContextCopyWith<$Res>(_value.requestContext!, (value) {
      return _then(_value.copyWith(requestContext: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $QueryCriteriaCopyWith<$Res>? get query {
    if (_value.query == null) {
      return null;
    }

    return $QueryCriteriaCopyWith<$Res>(_value.query!, (value) {
      return _then(_value.copyWith(query: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaginationStateImplCopyWith<T, $Res>
    implements $PaginationStateCopyWith<T, $Res> {
  factory _$$PaginationStateImplCopyWith(_$PaginationStateImpl<T> value,
          $Res Function(_$PaginationStateImpl<T>) then) =
      __$$PaginationStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {PaginationStatus status,
      List<T> items,
      PageMeta? meta,
      PaginationError? error,
      PaginationError? appendError,
      RequestContext? requestContext,
      bool isStale,
      DateTime? lastLoadedAt,
      QueryCriteria? query});

  @override
  $PaginationStatusCopyWith<$Res> get status;
  @override
  $PageMetaCopyWith<$Res>? get meta;
  @override
  $PaginationErrorCopyWith<$Res>? get error;
  @override
  $PaginationErrorCopyWith<$Res>? get appendError;
  @override
  $RequestContextCopyWith<$Res>? get requestContext;
  @override
  $QueryCriteriaCopyWith<$Res>? get query;
}

/// @nodoc
class __$$PaginationStateImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$PaginationStateImpl<T>>
    implements _$$PaginationStateImplCopyWith<T, $Res> {
  __$$PaginationStateImplCopyWithImpl(_$PaginationStateImpl<T> _value,
      $Res Function(_$PaginationStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? items = null,
    Object? meta = freezed,
    Object? error = freezed,
    Object? appendError = freezed,
    Object? requestContext = freezed,
    Object? isStale = null,
    Object? lastLoadedAt = freezed,
    Object? query = freezed,
  }) {
    return _then(_$PaginationStateImpl<T>(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaginationStatus,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PageMeta?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as PaginationError?,
      appendError: freezed == appendError
          ? _value.appendError
          : appendError // ignore: cast_nullable_to_non_nullable
              as PaginationError?,
      requestContext: freezed == requestContext
          ? _value.requestContext
          : requestContext // ignore: cast_nullable_to_non_nullable
              as RequestContext?,
      isStale: null == isStale
          ? _value.isStale
          : isStale // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoadedAt: freezed == lastLoadedAt
          ? _value.lastLoadedAt
          : lastLoadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as QueryCriteria?,
    ));
  }
}

/// @nodoc

class _$PaginationStateImpl<T> implements _PaginationState<T> {
  const _$PaginationStateImpl(
      {required this.status,
      final List<T> items = const [],
      this.meta,
      this.error,
      this.appendError,
      this.requestContext,
      this.isStale = false,
      this.lastLoadedAt,
      this.query})
      : _items = items;

  /// Current pagination status
  @override
  final PaginationStatus status;

  /// List of loaded items
  final List<T> _items;

  /// List of loaded items
  @override
  @JsonKey()
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Current pagination metadata
  @override
  final PageMeta? meta;

  /// Current error (if any)
  @override
  final PaginationError? error;

  /// Append error (non-blocking)
  @override
  final PaginationError? appendError;

  /// Current request context
  @override
  final RequestContext? requestContext;

  /// Whether data is stale and needs refresh
  @override
  @JsonKey()
  final bool isStale;

  /// Last successful load timestamp
  @override
  final DateTime? lastLoadedAt;

  /// Current search and filter criteria
  /// Defaults to empty criteria (no search, filters, or sorting)
  @override
  final QueryCriteria? query;

  @override
  String toString() {
    return 'PaginationState<$T>(status: $status, items: $items, meta: $meta, error: $error, appendError: $appendError, requestContext: $requestContext, isStale: $isStale, lastLoadedAt: $lastLoadedAt, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationStateImpl<T> &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.meta, meta) || other.meta == meta) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.appendError, appendError) ||
                other.appendError == appendError) &&
            (identical(other.requestContext, requestContext) ||
                other.requestContext == requestContext) &&
            (identical(other.isStale, isStale) || other.isStale == isStale) &&
            (identical(other.lastLoadedAt, lastLoadedAt) ||
                other.lastLoadedAt == lastLoadedAt) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_items),
      meta,
      error,
      appendError,
      requestContext,
      isStale,
      lastLoadedAt,
      query);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationStateImplCopyWith<T, _$PaginationStateImpl<T>> get copyWith =>
      __$$PaginationStateImplCopyWithImpl<T, _$PaginationStateImpl<T>>(
          this, _$identity);
}

abstract class _PaginationState<T> implements PaginationState<T> {
  const factory _PaginationState(
      {required final PaginationStatus status,
      final List<T> items,
      final PageMeta? meta,
      final PaginationError? error,
      final PaginationError? appendError,
      final RequestContext? requestContext,
      final bool isStale,
      final DateTime? lastLoadedAt,
      final QueryCriteria? query}) = _$PaginationStateImpl<T>;

  @override

  /// Current pagination status
  PaginationStatus get status;
  @override

  /// List of loaded items
  List<T> get items;
  @override

  /// Current pagination metadata
  PageMeta? get meta;
  @override

  /// Current error (if any)
  PaginationError? get error;
  @override

  /// Append error (non-blocking)
  PaginationError? get appendError;
  @override

  /// Current request context
  RequestContext? get requestContext;
  @override

  /// Whether data is stale and needs refresh
  bool get isStale;
  @override

  /// Last successful load timestamp
  DateTime? get lastLoadedAt;
  @override

  /// Current search and filter criteria
  /// Defaults to empty criteria (no search, filters, or sorting)
  QueryCriteria? get query;
  @override
  @JsonKey(ignore: true)
  _$$PaginationStateImplCopyWith<T, _$PaginationStateImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
