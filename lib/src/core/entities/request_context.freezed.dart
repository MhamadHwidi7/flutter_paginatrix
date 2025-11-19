// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestContext {
  /// Unique request ID for tracking
  String get requestId;

  /// Generation number to prevent stale responses
  int get generation;

  /// Cancel token for request cancellation
  CancelToken get cancelToken;

  /// Request timestamp
  DateTime get timestamp;

  /// Whether this is a refresh request
  bool get isRefresh;

  /// Whether this is an append request
  bool get isAppend;

  /// Additional metadata
  Map<String, dynamic> get metadata;

  /// Create a copy of RequestContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RequestContextCopyWith<RequestContext> get copyWith =>
      _$RequestContextCopyWithImpl<RequestContext>(
          this as RequestContext, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RequestContext &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.generation, generation) ||
                other.generation == generation) &&
            (identical(other.cancelToken, cancelToken) ||
                other.cancelToken == cancelToken) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isRefresh, isRefresh) ||
                other.isRefresh == isRefresh) &&
            (identical(other.isAppend, isAppend) ||
                other.isAppend == isAppend) &&
            const DeepCollectionEquality().equals(other.metadata, metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestId,
      generation,
      cancelToken,
      timestamp,
      isRefresh,
      isAppend,
      const DeepCollectionEquality().hash(metadata));

  @override
  String toString() {
    return 'RequestContext(requestId: $requestId, generation: $generation, cancelToken: $cancelToken, timestamp: $timestamp, isRefresh: $isRefresh, isAppend: $isAppend, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $RequestContextCopyWith<$Res> {
  factory $RequestContextCopyWith(
          RequestContext value, $Res Function(RequestContext) _then) =
      _$RequestContextCopyWithImpl;
  @useResult
  $Res call(
      {String requestId,
      int generation,
      CancelToken cancelToken,
      DateTime timestamp,
      bool isRefresh,
      bool isAppend,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$RequestContextCopyWithImpl<$Res>
    implements $RequestContextCopyWith<$Res> {
  _$RequestContextCopyWithImpl(this._self, this._then);

  final RequestContext _self;
  final $Res Function(RequestContext) _then;

  /// Create a copy of RequestContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? generation = null,
    Object? cancelToken = null,
    Object? timestamp = null,
    Object? isRefresh = null,
    Object? isAppend = null,
    Object? metadata = null,
  }) {
    return _then(_self.copyWith(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      generation: null == generation
          ? _self.generation
          : generation // ignore: cast_nullable_to_non_nullable
              as int,
      cancelToken: null == cancelToken
          ? _self.cancelToken
          : cancelToken // ignore: cast_nullable_to_non_nullable
              as CancelToken,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRefresh: null == isRefresh
          ? _self.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
      isAppend: null == isAppend
          ? _self.isAppend
          : isAppend // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RequestContext].
extension RequestContextPatterns on RequestContext {
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
    TResult Function(_RequestContext value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RequestContext() when $default != null:
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
    TResult Function(_RequestContext value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestContext():
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
    TResult? Function(_RequestContext value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestContext() when $default != null:
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
            String requestId,
            int generation,
            CancelToken cancelToken,
            DateTime timestamp,
            bool isRefresh,
            bool isAppend,
            Map<String, dynamic> metadata)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RequestContext() when $default != null:
        return $default(_that.requestId, _that.generation, _that.cancelToken,
            _that.timestamp, _that.isRefresh, _that.isAppend, _that.metadata);
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
            String requestId,
            int generation,
            CancelToken cancelToken,
            DateTime timestamp,
            bool isRefresh,
            bool isAppend,
            Map<String, dynamic> metadata)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestContext():
        return $default(_that.requestId, _that.generation, _that.cancelToken,
            _that.timestamp, _that.isRefresh, _that.isAppend, _that.metadata);
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
            String requestId,
            int generation,
            CancelToken cancelToken,
            DateTime timestamp,
            bool isRefresh,
            bool isAppend,
            Map<String, dynamic> metadata)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestContext() when $default != null:
        return $default(_that.requestId, _that.generation, _that.cancelToken,
            _that.timestamp, _that.isRefresh, _that.isAppend, _that.metadata);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RequestContext implements RequestContext {
  const _RequestContext(
      {required this.requestId,
      required this.generation,
      required this.cancelToken,
      required this.timestamp,
      this.isRefresh = false,
      this.isAppend = false,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  /// Unique request ID for tracking
  @override
  final String requestId;

  /// Generation number to prevent stale responses
  @override
  final int generation;

  /// Cancel token for request cancellation
  @override
  final CancelToken cancelToken;

  /// Request timestamp
  @override
  final DateTime timestamp;

  /// Whether this is a refresh request
  @override
  @JsonKey()
  final bool isRefresh;

  /// Whether this is an append request
  @override
  @JsonKey()
  final bool isAppend;

  /// Additional metadata
  final Map<String, dynamic> _metadata;

  /// Additional metadata
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  /// Create a copy of RequestContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RequestContextCopyWith<_RequestContext> get copyWith =>
      __$RequestContextCopyWithImpl<_RequestContext>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RequestContext &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.generation, generation) ||
                other.generation == generation) &&
            (identical(other.cancelToken, cancelToken) ||
                other.cancelToken == cancelToken) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isRefresh, isRefresh) ||
                other.isRefresh == isRefresh) &&
            (identical(other.isAppend, isAppend) ||
                other.isAppend == isAppend) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestId,
      generation,
      cancelToken,
      timestamp,
      isRefresh,
      isAppend,
      const DeepCollectionEquality().hash(_metadata));

  @override
  String toString() {
    return 'RequestContext(requestId: $requestId, generation: $generation, cancelToken: $cancelToken, timestamp: $timestamp, isRefresh: $isRefresh, isAppend: $isAppend, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$RequestContextCopyWith<$Res>
    implements $RequestContextCopyWith<$Res> {
  factory _$RequestContextCopyWith(
          _RequestContext value, $Res Function(_RequestContext) _then) =
      __$RequestContextCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String requestId,
      int generation,
      CancelToken cancelToken,
      DateTime timestamp,
      bool isRefresh,
      bool isAppend,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$RequestContextCopyWithImpl<$Res>
    implements _$RequestContextCopyWith<$Res> {
  __$RequestContextCopyWithImpl(this._self, this._then);

  final _RequestContext _self;
  final $Res Function(_RequestContext) _then;

  /// Create a copy of RequestContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? generation = null,
    Object? cancelToken = null,
    Object? timestamp = null,
    Object? isRefresh = null,
    Object? isAppend = null,
    Object? metadata = null,
  }) {
    return _then(_RequestContext(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      generation: null == generation
          ? _self.generation
          : generation // ignore: cast_nullable_to_non_nullable
              as int,
      cancelToken: null == cancelToken
          ? _self.cancelToken
          : cancelToken // ignore: cast_nullable_to_non_nullable
              as CancelToken,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRefresh: null == isRefresh
          ? _self.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
      isAppend: null == isAppend
          ? _self.isAppend
          : isAppend // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
