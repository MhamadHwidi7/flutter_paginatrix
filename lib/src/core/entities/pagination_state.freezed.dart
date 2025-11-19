// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginationState<T> {
  /// Current pagination status
  PaginationStatus get status;

  /// List of loaded items
  List<T> get items;

  /// Current pagination metadata
  PageMeta? get meta;

  /// Current error (if any)
  PaginationError? get error;

  /// Append error (non-blocking)
  PaginationError? get appendError;

  /// Current request context
  RequestContext? get requestContext;

  /// Whether data is stale and needs refresh
  bool get isStale;

  /// Last successful load timestamp
  DateTime? get lastLoadedAt;

  /// Current search and filter criteria
  /// Defaults to empty criteria (no search, filters, or sorting)
  QueryCriteria? get query;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaginationStateCopyWith<T, PaginationState<T>> get copyWith =>
      _$PaginationStateCopyWithImpl<T, PaginationState<T>>(
          this as PaginationState<T>, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaginationState<T> &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.items, items) &&
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
      const DeepCollectionEquality().hash(items),
      meta,
      error,
      appendError,
      requestContext,
      isStale,
      lastLoadedAt,
      query);

  @override
  String toString() {
    return 'PaginationState<$T>(status: $status, items: $items, meta: $meta, error: $error, appendError: $appendError, requestContext: $requestContext, isStale: $isStale, lastLoadedAt: $lastLoadedAt, query: $query)';
  }
}

/// @nodoc
abstract mixin class $PaginationStateCopyWith<T, $Res> {
  factory $PaginationStateCopyWith(
          PaginationState<T> value, $Res Function(PaginationState<T>) _then) =
      _$PaginationStateCopyWithImpl;
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
class _$PaginationStateCopyWithImpl<T, $Res>
    implements $PaginationStateCopyWith<T, $Res> {
  _$PaginationStateCopyWithImpl(this._self, this._then);

  final PaginationState<T> _self;
  final $Res Function(PaginationState<T>) _then;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
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
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaginationStatus,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PageMeta?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as PaginationError?,
      appendError: freezed == appendError
          ? _self.appendError
          : appendError // ignore: cast_nullable_to_non_nullable
              as PaginationError?,
      requestContext: freezed == requestContext
          ? _self.requestContext
          : requestContext // ignore: cast_nullable_to_non_nullable
              as RequestContext?,
      isStale: null == isStale
          ? _self.isStale
          : isStale // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoadedAt: freezed == lastLoadedAt
          ? _self.lastLoadedAt
          : lastLoadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      query: freezed == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as QueryCriteria?,
    ));
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationStatusCopyWith<$Res> get status {
    return $PaginationStatusCopyWith<$Res>(_self.status, (value) {
      return _then(_self.copyWith(status: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PageMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $PageMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
      return null;
    }

    return $PaginationErrorCopyWith<$Res>(_self.error!, (value) {
      return _then(_self.copyWith(error: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationErrorCopyWith<$Res>? get appendError {
    if (_self.appendError == null) {
      return null;
    }

    return $PaginationErrorCopyWith<$Res>(_self.appendError!, (value) {
      return _then(_self.copyWith(appendError: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequestContextCopyWith<$Res>? get requestContext {
    if (_self.requestContext == null) {
      return null;
    }

    return $RequestContextCopyWith<$Res>(_self.requestContext!, (value) {
      return _then(_self.copyWith(requestContext: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueryCriteriaCopyWith<$Res>? get query {
    if (_self.query == null) {
      return null;
    }

    return $QueryCriteriaCopyWith<$Res>(_self.query!, (value) {
      return _then(_self.copyWith(query: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PaginationState].
extension PaginationStatePatterns<T> on PaginationState<T> {
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
    TResult Function(_PaginationState<T> value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaginationState() when $default != null:
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
    TResult Function(_PaginationState<T> value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationState():
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
    TResult? Function(_PaginationState<T> value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationState() when $default != null:
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
            PaginationStatus status,
            List<T> items,
            PageMeta? meta,
            PaginationError? error,
            PaginationError? appendError,
            RequestContext? requestContext,
            bool isStale,
            DateTime? lastLoadedAt,
            QueryCriteria? query)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaginationState() when $default != null:
        return $default(
            _that.status,
            _that.items,
            _that.meta,
            _that.error,
            _that.appendError,
            _that.requestContext,
            _that.isStale,
            _that.lastLoadedAt,
            _that.query);
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
            PaginationStatus status,
            List<T> items,
            PageMeta? meta,
            PaginationError? error,
            PaginationError? appendError,
            RequestContext? requestContext,
            bool isStale,
            DateTime? lastLoadedAt,
            QueryCriteria? query)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationState():
        return $default(
            _that.status,
            _that.items,
            _that.meta,
            _that.error,
            _that.appendError,
            _that.requestContext,
            _that.isStale,
            _that.lastLoadedAt,
            _that.query);
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
            PaginationStatus status,
            List<T> items,
            PageMeta? meta,
            PaginationError? error,
            PaginationError? appendError,
            RequestContext? requestContext,
            bool isStale,
            DateTime? lastLoadedAt,
            QueryCriteria? query)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationState() when $default != null:
        return $default(
            _that.status,
            _that.items,
            _that.meta,
            _that.error,
            _that.appendError,
            _that.requestContext,
            _that.isStale,
            _that.lastLoadedAt,
            _that.query);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PaginationState<T> implements PaginationState<T> {
  const _PaginationState(
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

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PaginationStateCopyWith<T, _PaginationState<T>> get copyWith =>
      __$PaginationStateCopyWithImpl<T, _PaginationState<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PaginationState<T> &&
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

  @override
  String toString() {
    return 'PaginationState<$T>(status: $status, items: $items, meta: $meta, error: $error, appendError: $appendError, requestContext: $requestContext, isStale: $isStale, lastLoadedAt: $lastLoadedAt, query: $query)';
  }
}

/// @nodoc
abstract mixin class _$PaginationStateCopyWith<T, $Res>
    implements $PaginationStateCopyWith<T, $Res> {
  factory _$PaginationStateCopyWith(
          _PaginationState<T> value, $Res Function(_PaginationState<T>) _then) =
      __$PaginationStateCopyWithImpl;
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
class __$PaginationStateCopyWithImpl<T, $Res>
    implements _$PaginationStateCopyWith<T, $Res> {
  __$PaginationStateCopyWithImpl(this._self, this._then);

  final _PaginationState<T> _self;
  final $Res Function(_PaginationState<T>) _then;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_PaginationState<T>(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaginationStatus,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PageMeta?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as PaginationError?,
      appendError: freezed == appendError
          ? _self.appendError
          : appendError // ignore: cast_nullable_to_non_nullable
              as PaginationError?,
      requestContext: freezed == requestContext
          ? _self.requestContext
          : requestContext // ignore: cast_nullable_to_non_nullable
              as RequestContext?,
      isStale: null == isStale
          ? _self.isStale
          : isStale // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoadedAt: freezed == lastLoadedAt
          ? _self.lastLoadedAt
          : lastLoadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      query: freezed == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as QueryCriteria?,
    ));
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationStatusCopyWith<$Res> get status {
    return $PaginationStatusCopyWith<$Res>(_self.status, (value) {
      return _then(_self.copyWith(status: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PageMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $PageMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
      return null;
    }

    return $PaginationErrorCopyWith<$Res>(_self.error!, (value) {
      return _then(_self.copyWith(error: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationErrorCopyWith<$Res>? get appendError {
    if (_self.appendError == null) {
      return null;
    }

    return $PaginationErrorCopyWith<$Res>(_self.appendError!, (value) {
      return _then(_self.copyWith(appendError: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequestContextCopyWith<$Res>? get requestContext {
    if (_self.requestContext == null) {
      return null;
    }

    return $RequestContextCopyWith<$Res>(_self.requestContext!, (value) {
      return _then(_self.copyWith(requestContext: value));
    });
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueryCriteriaCopyWith<$Res>? get query {
    if (_self.query == null) {
      return null;
    }

    return $QueryCriteriaCopyWith<$Res>(_self.query!, (value) {
      return _then(_self.copyWith(query: value));
    });
  }
}

// dart format on
