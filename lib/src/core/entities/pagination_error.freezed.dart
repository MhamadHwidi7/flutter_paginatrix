// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginationError {
  String get message;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaginationErrorCopyWith<PaginationError> get copyWith =>
      _$PaginationErrorCopyWithImpl<PaginationError>(
          this as PaginationError, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaginationError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'PaginationError(message: $message)';
  }
}

/// @nodoc
abstract mixin class $PaginationErrorCopyWith<$Res> {
  factory $PaginationErrorCopyWith(
          PaginationError value, $Res Function(PaginationError) _then) =
      _$PaginationErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$PaginationErrorCopyWithImpl<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  _$PaginationErrorCopyWithImpl(this._self, this._then);

  final PaginationError _self;
  final $Res Function(PaginationError) _then;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PaginationError].
extension PaginationErrorPatterns on PaginationError {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NetworkError value)? network,
    TResult Function(_ParseError value)? parse,
    TResult Function(_CancelledError value)? cancelled,
    TResult Function(_RateLimitedError value)? rateLimited,
    TResult Function(_CircuitBreakerError value)? circuitBreaker,
    TResult Function(_UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NetworkError() when network != null:
        return network(_that);
      case _ParseError() when parse != null:
        return parse(_that);
      case _CancelledError() when cancelled != null:
        return cancelled(_that);
      case _RateLimitedError() when rateLimited != null:
        return rateLimited(_that);
      case _CircuitBreakerError() when circuitBreaker != null:
        return circuitBreaker(_that);
      case _UnknownError() when unknown != null:
        return unknown(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(_NetworkError value) network,
    required TResult Function(_ParseError value) parse,
    required TResult Function(_CancelledError value) cancelled,
    required TResult Function(_RateLimitedError value) rateLimited,
    required TResult Function(_CircuitBreakerError value) circuitBreaker,
    required TResult Function(_UnknownError value) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case _NetworkError():
        return network(_that);
      case _ParseError():
        return parse(_that);
      case _CancelledError():
        return cancelled(_that);
      case _RateLimitedError():
        return rateLimited(_that);
      case _CircuitBreakerError():
        return circuitBreaker(_that);
      case _UnknownError():
        return unknown(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NetworkError value)? network,
    TResult? Function(_ParseError value)? parse,
    TResult? Function(_CancelledError value)? cancelled,
    TResult? Function(_RateLimitedError value)? rateLimited,
    TResult? Function(_CircuitBreakerError value)? circuitBreaker,
    TResult? Function(_UnknownError value)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case _NetworkError() when network != null:
        return network(_that);
      case _ParseError() when parse != null:
        return parse(_that);
      case _CancelledError() when cancelled != null:
        return cancelled(_that);
      case _RateLimitedError() when rateLimited != null:
        return rateLimited(_that);
      case _CircuitBreakerError() when circuitBreaker != null:
        return circuitBreaker(_that);
      case _UnknownError() when unknown != null:
        return unknown(_that);
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
    final _that = this;
    switch (_that) {
      case _NetworkError() when network != null:
        return network(_that.message, _that.statusCode, _that.originalError);
      case _ParseError() when parse != null:
        return parse(_that.message, _that.expectedFormat, _that.actualData);
      case _CancelledError() when cancelled != null:
        return cancelled(_that.message);
      case _RateLimitedError() when rateLimited != null:
        return rateLimited(_that.message, _that.retryAfter);
      case _CircuitBreakerError() when circuitBreaker != null:
        return circuitBreaker(_that.message, _that.retryAfter);
      case _UnknownError() when unknown != null:
        return unknown(_that.message, _that.originalError);
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
    final _that = this;
    switch (_that) {
      case _NetworkError():
        return network(_that.message, _that.statusCode, _that.originalError);
      case _ParseError():
        return parse(_that.message, _that.expectedFormat, _that.actualData);
      case _CancelledError():
        return cancelled(_that.message);
      case _RateLimitedError():
        return rateLimited(_that.message, _that.retryAfter);
      case _CircuitBreakerError():
        return circuitBreaker(_that.message, _that.retryAfter);
      case _UnknownError():
        return unknown(_that.message, _that.originalError);
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
    final _that = this;
    switch (_that) {
      case _NetworkError() when network != null:
        return network(_that.message, _that.statusCode, _that.originalError);
      case _ParseError() when parse != null:
        return parse(_that.message, _that.expectedFormat, _that.actualData);
      case _CancelledError() when cancelled != null:
        return cancelled(_that.message);
      case _RateLimitedError() when rateLimited != null:
        return rateLimited(_that.message, _that.retryAfter);
      case _CircuitBreakerError() when circuitBreaker != null:
        return circuitBreaker(_that.message, _that.retryAfter);
      case _UnknownError() when unknown != null:
        return unknown(_that.message, _that.originalError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _NetworkError implements PaginationError {
  const _NetworkError(
      {required this.message, this.statusCode, this.originalError});

  @override
  final String message;
  final int? statusCode;
  final String? originalError;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NetworkErrorCopyWith<_NetworkError> get copyWith =>
      __$NetworkErrorCopyWithImpl<_NetworkError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NetworkError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.originalError, originalError) ||
                other.originalError == originalError));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, statusCode, originalError);

  @override
  String toString() {
    return 'PaginationError.network(message: $message, statusCode: $statusCode, originalError: $originalError)';
  }
}

/// @nodoc
abstract mixin class _$NetworkErrorCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$NetworkErrorCopyWith(
          _NetworkError value, $Res Function(_NetworkError) _then) =
      __$NetworkErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, int? statusCode, String? originalError});
}

/// @nodoc
class __$NetworkErrorCopyWithImpl<$Res>
    implements _$NetworkErrorCopyWith<$Res> {
  __$NetworkErrorCopyWithImpl(this._self, this._then);

  final _NetworkError _self;
  final $Res Function(_NetworkError) _then;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? statusCode = freezed,
    Object? originalError = freezed,
  }) {
    return _then(_NetworkError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: freezed == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      originalError: freezed == originalError
          ? _self.originalError
          : originalError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _ParseError implements PaginationError {
  const _ParseError(
      {required this.message, this.expectedFormat, this.actualData});

  @override
  final String message;
  final String? expectedFormat;
  final String? actualData;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParseErrorCopyWith<_ParseError> get copyWith =>
      __$ParseErrorCopyWithImpl<_ParseError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParseError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.expectedFormat, expectedFormat) ||
                other.expectedFormat == expectedFormat) &&
            (identical(other.actualData, actualData) ||
                other.actualData == actualData));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, expectedFormat, actualData);

  @override
  String toString() {
    return 'PaginationError.parse(message: $message, expectedFormat: $expectedFormat, actualData: $actualData)';
  }
}

/// @nodoc
abstract mixin class _$ParseErrorCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$ParseErrorCopyWith(
          _ParseError value, $Res Function(_ParseError) _then) =
      __$ParseErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, String? expectedFormat, String? actualData});
}

/// @nodoc
class __$ParseErrorCopyWithImpl<$Res> implements _$ParseErrorCopyWith<$Res> {
  __$ParseErrorCopyWithImpl(this._self, this._then);

  final _ParseError _self;
  final $Res Function(_ParseError) _then;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? expectedFormat = freezed,
    Object? actualData = freezed,
  }) {
    return _then(_ParseError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      expectedFormat: freezed == expectedFormat
          ? _self.expectedFormat
          : expectedFormat // ignore: cast_nullable_to_non_nullable
              as String?,
      actualData: freezed == actualData
          ? _self.actualData
          : actualData // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _CancelledError implements PaginationError {
  const _CancelledError({required this.message});

  @override
  final String message;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CancelledErrorCopyWith<_CancelledError> get copyWith =>
      __$CancelledErrorCopyWithImpl<_CancelledError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CancelledError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'PaginationError.cancelled(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$CancelledErrorCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$CancelledErrorCopyWith(
          _CancelledError value, $Res Function(_CancelledError) _then) =
      __$CancelledErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$CancelledErrorCopyWithImpl<$Res>
    implements _$CancelledErrorCopyWith<$Res> {
  __$CancelledErrorCopyWithImpl(this._self, this._then);

  final _CancelledError _self;
  final $Res Function(_CancelledError) _then;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_CancelledError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _RateLimitedError implements PaginationError {
  const _RateLimitedError({required this.message, this.retryAfter});

  @override
  final String message;
  final Duration? retryAfter;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RateLimitedErrorCopyWith<_RateLimitedError> get copyWith =>
      __$RateLimitedErrorCopyWithImpl<_RateLimitedError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RateLimitedError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.retryAfter, retryAfter) ||
                other.retryAfter == retryAfter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, retryAfter);

  @override
  String toString() {
    return 'PaginationError.rateLimited(message: $message, retryAfter: $retryAfter)';
  }
}

/// @nodoc
abstract mixin class _$RateLimitedErrorCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$RateLimitedErrorCopyWith(
          _RateLimitedError value, $Res Function(_RateLimitedError) _then) =
      __$RateLimitedErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, Duration? retryAfter});
}

/// @nodoc
class __$RateLimitedErrorCopyWithImpl<$Res>
    implements _$RateLimitedErrorCopyWith<$Res> {
  __$RateLimitedErrorCopyWithImpl(this._self, this._then);

  final _RateLimitedError _self;
  final $Res Function(_RateLimitedError) _then;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? retryAfter = freezed,
  }) {
    return _then(_RateLimitedError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      retryAfter: freezed == retryAfter
          ? _self.retryAfter
          : retryAfter // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc

class _CircuitBreakerError implements PaginationError {
  const _CircuitBreakerError({required this.message, this.retryAfter});

  @override
  final String message;
  final Duration? retryAfter;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CircuitBreakerErrorCopyWith<_CircuitBreakerError> get copyWith =>
      __$CircuitBreakerErrorCopyWithImpl<_CircuitBreakerError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CircuitBreakerError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.retryAfter, retryAfter) ||
                other.retryAfter == retryAfter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, retryAfter);

  @override
  String toString() {
    return 'PaginationError.circuitBreaker(message: $message, retryAfter: $retryAfter)';
  }
}

/// @nodoc
abstract mixin class _$CircuitBreakerErrorCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$CircuitBreakerErrorCopyWith(_CircuitBreakerError value,
          $Res Function(_CircuitBreakerError) _then) =
      __$CircuitBreakerErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, Duration? retryAfter});
}

/// @nodoc
class __$CircuitBreakerErrorCopyWithImpl<$Res>
    implements _$CircuitBreakerErrorCopyWith<$Res> {
  __$CircuitBreakerErrorCopyWithImpl(this._self, this._then);

  final _CircuitBreakerError _self;
  final $Res Function(_CircuitBreakerError) _then;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? retryAfter = freezed,
  }) {
    return _then(_CircuitBreakerError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      retryAfter: freezed == retryAfter
          ? _self.retryAfter
          : retryAfter // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc

class _UnknownError implements PaginationError {
  const _UnknownError({required this.message, this.originalError});

  @override
  final String message;
  final String? originalError;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UnknownErrorCopyWith<_UnknownError> get copyWith =>
      __$UnknownErrorCopyWithImpl<_UnknownError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UnknownError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.originalError, originalError) ||
                other.originalError == originalError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, originalError);

  @override
  String toString() {
    return 'PaginationError.unknown(message: $message, originalError: $originalError)';
  }
}

/// @nodoc
abstract mixin class _$UnknownErrorCopyWith<$Res>
    implements $PaginationErrorCopyWith<$Res> {
  factory _$UnknownErrorCopyWith(
          _UnknownError value, $Res Function(_UnknownError) _then) =
      __$UnknownErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, String? originalError});
}

/// @nodoc
class __$UnknownErrorCopyWithImpl<$Res>
    implements _$UnknownErrorCopyWith<$Res> {
  __$UnknownErrorCopyWithImpl(this._self, this._then);

  final _UnknownError _self;
  final $Res Function(_UnknownError) _then;

  /// Create a copy of PaginationError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
  }) {
    return _then(_UnknownError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError: freezed == originalError
          ? _self.originalError
          : originalError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
