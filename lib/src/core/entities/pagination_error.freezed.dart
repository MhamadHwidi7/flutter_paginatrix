// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaginationError {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String message, int? statusCode, String? originalError)
        network,
    required TResult Function(
            String message, String? expectedFormat, String? actualData)
        parse,
    required TResult Function(String message) cancelled,
    required TResult Function(String message, Duration? retryAfter) rateLimited,
    required TResult Function(String message, Duration? retryAfter)
        circuitBreaker,
    required TResult Function(String message, String? originalError) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? originalError)?
        network,
    TResult? Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult? Function(String message)? cancelled,
    TResult? Function(String message, Duration? retryAfter)? rateLimited,
    TResult? Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult? Function(String message, String? originalError)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? originalError)?
        network,
    TResult Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult Function(String message)? cancelled,
    TResult Function(String message, Duration? retryAfter)? rateLimited,
    TResult Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult Function(String message, String? originalError)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NetworkError value) network,
    required TResult Function(_ParseError value) parse,
    required TResult Function(_CancelledError value) cancelled,
    required TResult Function(_RateLimitedError value) rateLimited,
    required TResult Function(_CircuitBreakerError value) circuitBreaker,
    required TResult Function(_UnknownError value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NetworkError value)? network,
    TResult? Function(_ParseError value)? parse,
    TResult? Function(_CancelledError value)? cancelled,
    TResult? Function(_RateLimitedError value)? rateLimited,
    TResult? Function(_CircuitBreakerError value)? circuitBreaker,
    TResult? Function(_UnknownError value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NetworkError value)? network,
    TResult Function(_ParseError value)? parse,
    TResult Function(_CancelledError value)? cancelled,
    TResult Function(_RateLimitedError value)? rateLimited,
    TResult Function(_CircuitBreakerError value)? circuitBreaker,
    TResult Function(_UnknownError value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PaginationErrorCopyWith<PaginationError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationErrorCopyWith<$Res> {
  factory $PaginationErrorCopyWith(
          PaginationError value, $Res Function(PaginationError) then) =
      _$PaginationErrorCopyWithImpl<$Res, PaginationError>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$PaginationErrorCopyWithImpl<$Res, $Val extends PaginationError>
    implements $PaginationErrorCopyWith<$Res> {
  _$PaginationErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkErrorImplCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$$NetworkErrorImplCopyWith(
          _$NetworkErrorImpl value, $Res Function(_$NetworkErrorImpl) then) =
      __$$NetworkErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? statusCode, String? originalError});
}

/// @nodoc
class __$$NetworkErrorImplCopyWithImpl<$Res>
    extends _$PaginationErrorCopyWithImpl<$Res, _$NetworkErrorImpl>
    implements _$$NetworkErrorImplCopyWith<$Res> {
  __$$NetworkErrorImplCopyWithImpl(
      _$NetworkErrorImpl _value, $Res Function(_$NetworkErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? statusCode = freezed,
    Object? originalError = freezed,
  }) {
    return _then(_$NetworkErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      originalError: freezed == originalError
          ? _value.originalError
          : originalError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NetworkErrorImpl implements _NetworkError {
  const _$NetworkErrorImpl(
      {required this.message, this.statusCode, this.originalError});

  @override
  final String message;
  @override
  final int? statusCode;
  @override
  final String? originalError;

  @override
  String toString() {
    return 'PaginationError.network(message: $message, statusCode: $statusCode, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.originalError, originalError) ||
                other.originalError == originalError));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, statusCode, originalError);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkErrorImplCopyWith<_$NetworkErrorImpl> get copyWith =>
      __$$NetworkErrorImplCopyWithImpl<_$NetworkErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String message, int? statusCode, String? originalError)
        network,
    required TResult Function(
            String message, String? expectedFormat, String? actualData)
        parse,
    required TResult Function(String message) cancelled,
    required TResult Function(String message, Duration? retryAfter) rateLimited,
    required TResult Function(String message, Duration? retryAfter)
        circuitBreaker,
    required TResult Function(String message, String? originalError) unknown,
  }) {
    return network(message, statusCode, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? originalError)?
        network,
    TResult? Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult? Function(String message)? cancelled,
    TResult? Function(String message, Duration? retryAfter)? rateLimited,
    TResult? Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult? Function(String message, String? originalError)? unknown,
  }) {
    return network?.call(message, statusCode, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? originalError)?
        network,
    TResult Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult Function(String message)? cancelled,
    TResult Function(String message, Duration? retryAfter)? rateLimited,
    TResult Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult Function(String message, String? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message, statusCode, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NetworkError value) network,
    required TResult Function(_ParseError value) parse,
    required TResult Function(_CancelledError value) cancelled,
    required TResult Function(_RateLimitedError value) rateLimited,
    required TResult Function(_CircuitBreakerError value) circuitBreaker,
    required TResult Function(_UnknownError value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NetworkError value)? network,
    TResult? Function(_ParseError value)? parse,
    TResult? Function(_CancelledError value)? cancelled,
    TResult? Function(_RateLimitedError value)? rateLimited,
    TResult? Function(_CircuitBreakerError value)? circuitBreaker,
    TResult? Function(_UnknownError value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NetworkError value)? network,
    TResult Function(_ParseError value)? parse,
    TResult Function(_CancelledError value)? cancelled,
    TResult Function(_RateLimitedError value)? rateLimited,
    TResult Function(_CircuitBreakerError value)? circuitBreaker,
    TResult Function(_UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class _NetworkError implements PaginationError {
  const factory _NetworkError(
      {required final String message,
      final int? statusCode,
      final String? originalError}) = _$NetworkErrorImpl;

  @override
  String get message;
  int? get statusCode;
  String? get originalError;
  @override
  @JsonKey(ignore: true)
  _$$NetworkErrorImplCopyWith<_$NetworkErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParseErrorImplCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$$ParseErrorImplCopyWith(
          _$ParseErrorImpl value, $Res Function(_$ParseErrorImpl) then) =
      __$$ParseErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? expectedFormat, String? actualData});
}

/// @nodoc
class __$$ParseErrorImplCopyWithImpl<$Res>
    extends _$PaginationErrorCopyWithImpl<$Res, _$ParseErrorImpl>
    implements _$$ParseErrorImplCopyWith<$Res> {
  __$$ParseErrorImplCopyWithImpl(
      _$ParseErrorImpl _value, $Res Function(_$ParseErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? expectedFormat = freezed,
    Object? actualData = freezed,
  }) {
    return _then(_$ParseErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      expectedFormat: freezed == expectedFormat
          ? _value.expectedFormat
          : expectedFormat // ignore: cast_nullable_to_non_nullable
              as String?,
      actualData: freezed == actualData
          ? _value.actualData
          : actualData // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ParseErrorImpl implements _ParseError {
  const _$ParseErrorImpl(
      {required this.message, this.expectedFormat, this.actualData});

  @override
  final String message;
  @override
  final String? expectedFormat;
  @override
  final String? actualData;

  @override
  String toString() {
    return 'PaginationError.parse(message: $message, expectedFormat: $expectedFormat, actualData: $actualData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParseErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.expectedFormat, expectedFormat) ||
                other.expectedFormat == expectedFormat) &&
            (identical(other.actualData, actualData) ||
                other.actualData == actualData));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, expectedFormat, actualData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParseErrorImplCopyWith<_$ParseErrorImpl> get copyWith =>
      __$$ParseErrorImplCopyWithImpl<_$ParseErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String message, int? statusCode, String? originalError)
        network,
    required TResult Function(
            String message, String? expectedFormat, String? actualData)
        parse,
    required TResult Function(String message) cancelled,
    required TResult Function(String message, Duration? retryAfter) rateLimited,
    required TResult Function(String message, Duration? retryAfter)
        circuitBreaker,
    required TResult Function(String message, String? originalError) unknown,
  }) {
    return parse(message, expectedFormat, actualData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? originalError)?
        network,
    TResult? Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult? Function(String message)? cancelled,
    TResult? Function(String message, Duration? retryAfter)? rateLimited,
    TResult? Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult? Function(String message, String? originalError)? unknown,
  }) {
    return parse?.call(message, expectedFormat, actualData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? originalError)?
        network,
    TResult Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult Function(String message)? cancelled,
    TResult Function(String message, Duration? retryAfter)? rateLimited,
    TResult Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult Function(String message, String? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (parse != null) {
      return parse(message, expectedFormat, actualData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NetworkError value) network,
    required TResult Function(_ParseError value) parse,
    required TResult Function(_CancelledError value) cancelled,
    required TResult Function(_RateLimitedError value) rateLimited,
    required TResult Function(_CircuitBreakerError value) circuitBreaker,
    required TResult Function(_UnknownError value) unknown,
  }) {
    return parse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NetworkError value)? network,
    TResult? Function(_ParseError value)? parse,
    TResult? Function(_CancelledError value)? cancelled,
    TResult? Function(_RateLimitedError value)? rateLimited,
    TResult? Function(_CircuitBreakerError value)? circuitBreaker,
    TResult? Function(_UnknownError value)? unknown,
  }) {
    return parse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NetworkError value)? network,
    TResult Function(_ParseError value)? parse,
    TResult Function(_CancelledError value)? cancelled,
    TResult Function(_RateLimitedError value)? rateLimited,
    TResult Function(_CircuitBreakerError value)? circuitBreaker,
    TResult Function(_UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (parse != null) {
      return parse(this);
    }
    return orElse();
  }
}

abstract class _ParseError implements PaginationError {
  const factory _ParseError(
      {required final String message,
      final String? expectedFormat,
      final String? actualData}) = _$ParseErrorImpl;

  @override
  String get message;
  String? get expectedFormat;
  String? get actualData;
  @override
  @JsonKey(ignore: true)
  _$$ParseErrorImplCopyWith<_$ParseErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CancelledErrorImplCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$$CancelledErrorImplCopyWith(_$CancelledErrorImpl value,
          $Res Function(_$CancelledErrorImpl) then) =
      __$$CancelledErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CancelledErrorImplCopyWithImpl<$Res>
    extends _$PaginationErrorCopyWithImpl<$Res, _$CancelledErrorImpl>
    implements _$$CancelledErrorImplCopyWith<$Res> {
  __$$CancelledErrorImplCopyWithImpl(
      _$CancelledErrorImpl _value, $Res Function(_$CancelledErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$CancelledErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CancelledErrorImpl implements _CancelledError {
  const _$CancelledErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'PaginationError.cancelled(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelledErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelledErrorImplCopyWith<_$CancelledErrorImpl> get copyWith =>
      __$$CancelledErrorImplCopyWithImpl<_$CancelledErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String message, int? statusCode, String? originalError)
        network,
    required TResult Function(
            String message, String? expectedFormat, String? actualData)
        parse,
    required TResult Function(String message) cancelled,
    required TResult Function(String message, Duration? retryAfter) rateLimited,
    required TResult Function(String message, Duration? retryAfter)
        circuitBreaker,
    required TResult Function(String message, String? originalError) unknown,
  }) {
    return cancelled(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? originalError)?
        network,
    TResult? Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult? Function(String message)? cancelled,
    TResult? Function(String message, Duration? retryAfter)? rateLimited,
    TResult? Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult? Function(String message, String? originalError)? unknown,
  }) {
    return cancelled?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? originalError)?
        network,
    TResult Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult Function(String message)? cancelled,
    TResult Function(String message, Duration? retryAfter)? rateLimited,
    TResult Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult Function(String message, String? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NetworkError value) network,
    required TResult Function(_ParseError value) parse,
    required TResult Function(_CancelledError value) cancelled,
    required TResult Function(_RateLimitedError value) rateLimited,
    required TResult Function(_CircuitBreakerError value) circuitBreaker,
    required TResult Function(_UnknownError value) unknown,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NetworkError value)? network,
    TResult? Function(_ParseError value)? parse,
    TResult? Function(_CancelledError value)? cancelled,
    TResult? Function(_RateLimitedError value)? rateLimited,
    TResult? Function(_CircuitBreakerError value)? circuitBreaker,
    TResult? Function(_UnknownError value)? unknown,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NetworkError value)? network,
    TResult Function(_ParseError value)? parse,
    TResult Function(_CancelledError value)? cancelled,
    TResult Function(_RateLimitedError value)? rateLimited,
    TResult Function(_CircuitBreakerError value)? circuitBreaker,
    TResult Function(_UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class _CancelledError implements PaginationError {
  const factory _CancelledError({required final String message}) =
      _$CancelledErrorImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$CancelledErrorImplCopyWith<_$CancelledErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RateLimitedErrorImplCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$$RateLimitedErrorImplCopyWith(_$RateLimitedErrorImpl value,
          $Res Function(_$RateLimitedErrorImpl) then) =
      __$$RateLimitedErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Duration? retryAfter});
}

/// @nodoc
class __$$RateLimitedErrorImplCopyWithImpl<$Res>
    extends _$PaginationErrorCopyWithImpl<$Res, _$RateLimitedErrorImpl>
    implements _$$RateLimitedErrorImplCopyWith<$Res> {
  __$$RateLimitedErrorImplCopyWithImpl(_$RateLimitedErrorImpl _value,
      $Res Function(_$RateLimitedErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? retryAfter = freezed,
  }) {
    return _then(_$RateLimitedErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      retryAfter: freezed == retryAfter
          ? _value.retryAfter
          : retryAfter // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc

class _$RateLimitedErrorImpl implements _RateLimitedError {
  const _$RateLimitedErrorImpl({required this.message, this.retryAfter});

  @override
  final String message;
  @override
  final Duration? retryAfter;

  @override
  String toString() {
    return 'PaginationError.rateLimited(message: $message, retryAfter: $retryAfter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RateLimitedErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.retryAfter, retryAfter) ||
                other.retryAfter == retryAfter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, retryAfter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RateLimitedErrorImplCopyWith<_$RateLimitedErrorImpl> get copyWith =>
      __$$RateLimitedErrorImplCopyWithImpl<_$RateLimitedErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String message, int? statusCode, String? originalError)
        network,
    required TResult Function(
            String message, String? expectedFormat, String? actualData)
        parse,
    required TResult Function(String message) cancelled,
    required TResult Function(String message, Duration? retryAfter) rateLimited,
    required TResult Function(String message, Duration? retryAfter)
        circuitBreaker,
    required TResult Function(String message, String? originalError) unknown,
  }) {
    return rateLimited(message, retryAfter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? originalError)?
        network,
    TResult? Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult? Function(String message)? cancelled,
    TResult? Function(String message, Duration? retryAfter)? rateLimited,
    TResult? Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult? Function(String message, String? originalError)? unknown,
  }) {
    return rateLimited?.call(message, retryAfter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? originalError)?
        network,
    TResult Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult Function(String message)? cancelled,
    TResult Function(String message, Duration? retryAfter)? rateLimited,
    TResult Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult Function(String message, String? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (rateLimited != null) {
      return rateLimited(message, retryAfter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NetworkError value) network,
    required TResult Function(_ParseError value) parse,
    required TResult Function(_CancelledError value) cancelled,
    required TResult Function(_RateLimitedError value) rateLimited,
    required TResult Function(_CircuitBreakerError value) circuitBreaker,
    required TResult Function(_UnknownError value) unknown,
  }) {
    return rateLimited(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NetworkError value)? network,
    TResult? Function(_ParseError value)? parse,
    TResult? Function(_CancelledError value)? cancelled,
    TResult? Function(_RateLimitedError value)? rateLimited,
    TResult? Function(_CircuitBreakerError value)? circuitBreaker,
    TResult? Function(_UnknownError value)? unknown,
  }) {
    return rateLimited?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NetworkError value)? network,
    TResult Function(_ParseError value)? parse,
    TResult Function(_CancelledError value)? cancelled,
    TResult Function(_RateLimitedError value)? rateLimited,
    TResult Function(_CircuitBreakerError value)? circuitBreaker,
    TResult Function(_UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (rateLimited != null) {
      return rateLimited(this);
    }
    return orElse();
  }
}

abstract class _RateLimitedError implements PaginationError {
  const factory _RateLimitedError(
      {required final String message,
      final Duration? retryAfter}) = _$RateLimitedErrorImpl;

  @override
  String get message;
  Duration? get retryAfter;
  @override
  @JsonKey(ignore: true)
  _$$RateLimitedErrorImplCopyWith<_$RateLimitedErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CircuitBreakerErrorImplCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$$CircuitBreakerErrorImplCopyWith(_$CircuitBreakerErrorImpl value,
          $Res Function(_$CircuitBreakerErrorImpl) then) =
      __$$CircuitBreakerErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Duration? retryAfter});
}

/// @nodoc
class __$$CircuitBreakerErrorImplCopyWithImpl<$Res>
    extends _$PaginationErrorCopyWithImpl<$Res, _$CircuitBreakerErrorImpl>
    implements _$$CircuitBreakerErrorImplCopyWith<$Res> {
  __$$CircuitBreakerErrorImplCopyWithImpl(_$CircuitBreakerErrorImpl _value,
      $Res Function(_$CircuitBreakerErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? retryAfter = freezed,
  }) {
    return _then(_$CircuitBreakerErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      retryAfter: freezed == retryAfter
          ? _value.retryAfter
          : retryAfter // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc

class _$CircuitBreakerErrorImpl implements _CircuitBreakerError {
  const _$CircuitBreakerErrorImpl({required this.message, this.retryAfter});

  @override
  final String message;
  @override
  final Duration? retryAfter;

  @override
  String toString() {
    return 'PaginationError.circuitBreaker(message: $message, retryAfter: $retryAfter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CircuitBreakerErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.retryAfter, retryAfter) ||
                other.retryAfter == retryAfter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, retryAfter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CircuitBreakerErrorImplCopyWith<_$CircuitBreakerErrorImpl> get copyWith =>
      __$$CircuitBreakerErrorImplCopyWithImpl<_$CircuitBreakerErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String message, int? statusCode, String? originalError)
        network,
    required TResult Function(
            String message, String? expectedFormat, String? actualData)
        parse,
    required TResult Function(String message) cancelled,
    required TResult Function(String message, Duration? retryAfter) rateLimited,
    required TResult Function(String message, Duration? retryAfter)
        circuitBreaker,
    required TResult Function(String message, String? originalError) unknown,
  }) {
    return circuitBreaker(message, retryAfter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? originalError)?
        network,
    TResult? Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult? Function(String message)? cancelled,
    TResult? Function(String message, Duration? retryAfter)? rateLimited,
    TResult? Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult? Function(String message, String? originalError)? unknown,
  }) {
    return circuitBreaker?.call(message, retryAfter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? originalError)?
        network,
    TResult Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult Function(String message)? cancelled,
    TResult Function(String message, Duration? retryAfter)? rateLimited,
    TResult Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult Function(String message, String? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (circuitBreaker != null) {
      return circuitBreaker(message, retryAfter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NetworkError value) network,
    required TResult Function(_ParseError value) parse,
    required TResult Function(_CancelledError value) cancelled,
    required TResult Function(_RateLimitedError value) rateLimited,
    required TResult Function(_CircuitBreakerError value) circuitBreaker,
    required TResult Function(_UnknownError value) unknown,
  }) {
    return circuitBreaker(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NetworkError value)? network,
    TResult? Function(_ParseError value)? parse,
    TResult? Function(_CancelledError value)? cancelled,
    TResult? Function(_RateLimitedError value)? rateLimited,
    TResult? Function(_CircuitBreakerError value)? circuitBreaker,
    TResult? Function(_UnknownError value)? unknown,
  }) {
    return circuitBreaker?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NetworkError value)? network,
    TResult Function(_ParseError value)? parse,
    TResult Function(_CancelledError value)? cancelled,
    TResult Function(_RateLimitedError value)? rateLimited,
    TResult Function(_CircuitBreakerError value)? circuitBreaker,
    TResult Function(_UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (circuitBreaker != null) {
      return circuitBreaker(this);
    }
    return orElse();
  }
}

abstract class _CircuitBreakerError implements PaginationError {
  const factory _CircuitBreakerError(
      {required final String message,
      final Duration? retryAfter}) = _$CircuitBreakerErrorImpl;

  @override
  String get message;
  Duration? get retryAfter;
  @override
  @JsonKey(ignore: true)
  _$$CircuitBreakerErrorImplCopyWith<_$CircuitBreakerErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownErrorImplCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$$UnknownErrorImplCopyWith(
          _$UnknownErrorImpl value, $Res Function(_$UnknownErrorImpl) then) =
      __$$UnknownErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? originalError});
}

/// @nodoc
class __$$UnknownErrorImplCopyWithImpl<$Res>
    extends _$PaginationErrorCopyWithImpl<$Res, _$UnknownErrorImpl>
    implements _$$UnknownErrorImplCopyWith<$Res> {
  __$$UnknownErrorImplCopyWithImpl(
      _$UnknownErrorImpl _value, $Res Function(_$UnknownErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
  }) {
    return _then(_$UnknownErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError: freezed == originalError
          ? _value.originalError
          : originalError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UnknownErrorImpl implements _UnknownError {
  const _$UnknownErrorImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final String? originalError;

  @override
  String toString() {
    return 'PaginationError.unknown(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.originalError, originalError) ||
                other.originalError == originalError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, originalError);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      __$$UnknownErrorImplCopyWithImpl<_$UnknownErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String message, int? statusCode, String? originalError)
        network,
    required TResult Function(
            String message, String? expectedFormat, String? actualData)
        parse,
    required TResult Function(String message) cancelled,
    required TResult Function(String message, Duration? retryAfter) rateLimited,
    required TResult Function(String message, Duration? retryAfter)
        circuitBreaker,
    required TResult Function(String message, String? originalError) unknown,
  }) {
    return unknown(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? originalError)?
        network,
    TResult? Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult? Function(String message)? cancelled,
    TResult? Function(String message, Duration? retryAfter)? rateLimited,
    TResult? Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult? Function(String message, String? originalError)? unknown,
  }) {
    return unknown?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? originalError)?
        network,
    TResult Function(
            String message, String? expectedFormat, String? actualData)?
        parse,
    TResult Function(String message)? cancelled,
    TResult Function(String message, Duration? retryAfter)? rateLimited,
    TResult Function(String message, Duration? retryAfter)? circuitBreaker,
    TResult Function(String message, String? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NetworkError value) network,
    required TResult Function(_ParseError value) parse,
    required TResult Function(_CancelledError value) cancelled,
    required TResult Function(_RateLimitedError value) rateLimited,
    required TResult Function(_CircuitBreakerError value) circuitBreaker,
    required TResult Function(_UnknownError value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NetworkError value)? network,
    TResult? Function(_ParseError value)? parse,
    TResult? Function(_CancelledError value)? cancelled,
    TResult? Function(_RateLimitedError value)? rateLimited,
    TResult? Function(_CircuitBreakerError value)? circuitBreaker,
    TResult? Function(_UnknownError value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NetworkError value)? network,
    TResult Function(_ParseError value)? parse,
    TResult Function(_CancelledError value)? cancelled,
    TResult Function(_RateLimitedError value)? rateLimited,
    TResult Function(_CircuitBreakerError value)? circuitBreaker,
    TResult Function(_UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _UnknownError implements PaginationError {
  const factory _UnknownError(
      {required final String message,
      final String? originalError}) = _$UnknownErrorImpl;

  @override
  String get message;
  String? get originalError;
  @override
  @JsonKey(ignore: true)
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
