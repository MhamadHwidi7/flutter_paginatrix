// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RequestContext {
  /// Unique request ID for tracking
  String get requestId => throw _privateConstructorUsedError;

  /// Generation number to prevent stale responses
  int get generation => throw _privateConstructorUsedError;

  /// Cancel token for request cancellation
  CancelToken get cancelToken => throw _privateConstructorUsedError;

  /// Request timestamp
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Whether this is a refresh request
  bool get isRefresh => throw _privateConstructorUsedError;

  /// Whether this is an append request
  bool get isAppend => throw _privateConstructorUsedError;

  /// Additional metadata
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RequestContextCopyWith<RequestContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestContextCopyWith<$Res> {
  factory $RequestContextCopyWith(
          RequestContext value, $Res Function(RequestContext) then) =
      _$RequestContextCopyWithImpl<$Res, RequestContext>;
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
class _$RequestContextCopyWithImpl<$Res, $Val extends RequestContext>
    implements $RequestContextCopyWith<$Res> {
  _$RequestContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      generation: null == generation
          ? _value.generation
          : generation // ignore: cast_nullable_to_non_nullable
              as int,
      cancelToken: null == cancelToken
          ? _value.cancelToken
          : cancelToken // ignore: cast_nullable_to_non_nullable
              as CancelToken,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRefresh: null == isRefresh
          ? _value.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
      isAppend: null == isAppend
          ? _value.isAppend
          : isAppend // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestContextImplCopyWith<$Res>
    implements $RequestContextCopyWith<$Res> {
  factory _$$RequestContextImplCopyWith(_$RequestContextImpl value,
          $Res Function(_$RequestContextImpl) then) =
      __$$RequestContextImplCopyWithImpl<$Res>;
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
class __$$RequestContextImplCopyWithImpl<$Res>
    extends _$RequestContextCopyWithImpl<$Res, _$RequestContextImpl>
    implements _$$RequestContextImplCopyWith<$Res> {
  __$$RequestContextImplCopyWithImpl(
      _$RequestContextImpl _value, $Res Function(_$RequestContextImpl) _then)
      : super(_value, _then);

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
    return _then(_$RequestContextImpl(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      generation: null == generation
          ? _value.generation
          : generation // ignore: cast_nullable_to_non_nullable
              as int,
      cancelToken: null == cancelToken
          ? _value.cancelToken
          : cancelToken // ignore: cast_nullable_to_non_nullable
              as CancelToken,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRefresh: null == isRefresh
          ? _value.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
      isAppend: null == isAppend
          ? _value.isAppend
          : isAppend // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$RequestContextImpl implements _RequestContext {
  const _$RequestContextImpl(
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

  @override
  String toString() {
    return 'RequestContext(requestId: $requestId, generation: $generation, cancelToken: $cancelToken, timestamp: $timestamp, isRefresh: $isRefresh, isAppend: $isAppend, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestContextImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestContextImplCopyWith<_$RequestContextImpl> get copyWith =>
      __$$RequestContextImplCopyWithImpl<_$RequestContextImpl>(
          this, _$identity);
}

abstract class _RequestContext implements RequestContext {
  const factory _RequestContext(
      {required final String requestId,
      required final int generation,
      required final CancelToken cancelToken,
      required final DateTime timestamp,
      final bool isRefresh,
      final bool isAppend,
      final Map<String, dynamic> metadata}) = _$RequestContextImpl;

  @override

  /// Unique request ID for tracking
  String get requestId;
  @override

  /// Generation number to prevent stale responses
  int get generation;
  @override

  /// Cancel token for request cancellation
  CancelToken get cancelToken;
  @override

  /// Request timestamp
  DateTime get timestamp;
  @override

  /// Whether this is a refresh request
  bool get isRefresh;
  @override

  /// Whether this is an append request
  bool get isAppend;
  @override

  /// Additional metadata
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$RequestContextImplCopyWith<_$RequestContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
