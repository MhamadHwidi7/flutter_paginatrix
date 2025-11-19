// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginationOptions {
  /// Default page size
  int get defaultPageSize;

  /// Maximum page size
  int get maxPageSize;

  /// Request timeout
  Duration get requestTimeout;

  /// Whether to enable debug logging
  bool get enableDebugLogging;

  /// Default prefetch threshold (number of items from end to trigger load)
  int get defaultPrefetchThreshold;

  /// Default prefetch threshold in pixels (if threshold is not set)
  double get defaultPrefetchThresholdPixels;

  /// Maximum number of retry attempts
  int get maxRetries;

  /// Initial backoff duration for retry attempts
  Duration get initialBackoff;

  /// Retry reset timeout (resets retry count after this duration)
  Duration get retryResetTimeout;

  /// Debounce duration for refresh calls to prevent rapid successive refreshes
  Duration get refreshDebounceDuration;

  /// Debounce duration for search term updates to prevent excessive API calls
  /// while user is typing
  Duration get searchDebounceDuration;

  /// Create a copy of PaginationOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaginationOptionsCopyWith<PaginationOptions> get copyWith =>
      _$PaginationOptionsCopyWithImpl<PaginationOptions>(
          this as PaginationOptions, _$identity);

  /// Serializes this PaginationOptions to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaginationOptions &&
            (identical(other.defaultPageSize, defaultPageSize) ||
                other.defaultPageSize == defaultPageSize) &&
            (identical(other.maxPageSize, maxPageSize) ||
                other.maxPageSize == maxPageSize) &&
            (identical(other.requestTimeout, requestTimeout) ||
                other.requestTimeout == requestTimeout) &&
            (identical(other.enableDebugLogging, enableDebugLogging) ||
                other.enableDebugLogging == enableDebugLogging) &&
            (identical(
                    other.defaultPrefetchThreshold, defaultPrefetchThreshold) ||
                other.defaultPrefetchThreshold == defaultPrefetchThreshold) &&
            (identical(other.defaultPrefetchThresholdPixels,
                    defaultPrefetchThresholdPixels) ||
                other.defaultPrefetchThresholdPixels ==
                    defaultPrefetchThresholdPixels) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.initialBackoff, initialBackoff) ||
                other.initialBackoff == initialBackoff) &&
            (identical(other.retryResetTimeout, retryResetTimeout) ||
                other.retryResetTimeout == retryResetTimeout) &&
            (identical(
                    other.refreshDebounceDuration, refreshDebounceDuration) ||
                other.refreshDebounceDuration == refreshDebounceDuration) &&
            (identical(other.searchDebounceDuration, searchDebounceDuration) ||
                other.searchDebounceDuration == searchDebounceDuration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      defaultPageSize,
      maxPageSize,
      requestTimeout,
      enableDebugLogging,
      defaultPrefetchThreshold,
      defaultPrefetchThresholdPixels,
      maxRetries,
      initialBackoff,
      retryResetTimeout,
      refreshDebounceDuration,
      searchDebounceDuration);

  @override
  String toString() {
    return 'PaginationOptions(defaultPageSize: $defaultPageSize, maxPageSize: $maxPageSize, requestTimeout: $requestTimeout, enableDebugLogging: $enableDebugLogging, defaultPrefetchThreshold: $defaultPrefetchThreshold, defaultPrefetchThresholdPixels: $defaultPrefetchThresholdPixels, maxRetries: $maxRetries, initialBackoff: $initialBackoff, retryResetTimeout: $retryResetTimeout, refreshDebounceDuration: $refreshDebounceDuration, searchDebounceDuration: $searchDebounceDuration)';
  }
}

/// @nodoc
abstract mixin class $PaginationOptionsCopyWith<$Res> {
  factory $PaginationOptionsCopyWith(
          PaginationOptions value, $Res Function(PaginationOptions) _then) =
      _$PaginationOptionsCopyWithImpl;
  @useResult
  $Res call(
      {int defaultPageSize,
      int maxPageSize,
      Duration requestTimeout,
      bool enableDebugLogging,
      int defaultPrefetchThreshold,
      double defaultPrefetchThresholdPixels,
      int maxRetries,
      Duration initialBackoff,
      Duration retryResetTimeout,
      Duration refreshDebounceDuration,
      Duration searchDebounceDuration});
}

/// @nodoc
class _$PaginationOptionsCopyWithImpl<$Res>
    implements $PaginationOptionsCopyWith<$Res> {
  _$PaginationOptionsCopyWithImpl(this._self, this._then);

  final PaginationOptions _self;
  final $Res Function(PaginationOptions) _then;

  /// Create a copy of PaginationOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultPageSize = null,
    Object? maxPageSize = null,
    Object? requestTimeout = null,
    Object? enableDebugLogging = null,
    Object? defaultPrefetchThreshold = null,
    Object? defaultPrefetchThresholdPixels = null,
    Object? maxRetries = null,
    Object? initialBackoff = null,
    Object? retryResetTimeout = null,
    Object? refreshDebounceDuration = null,
    Object? searchDebounceDuration = null,
  }) {
    return _then(_self.copyWith(
      defaultPageSize: null == defaultPageSize
          ? _self.defaultPageSize
          : defaultPageSize // ignore: cast_nullable_to_non_nullable
              as int,
      maxPageSize: null == maxPageSize
          ? _self.maxPageSize
          : maxPageSize // ignore: cast_nullable_to_non_nullable
              as int,
      requestTimeout: null == requestTimeout
          ? _self.requestTimeout
          : requestTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      enableDebugLogging: null == enableDebugLogging
          ? _self.enableDebugLogging
          : enableDebugLogging // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultPrefetchThreshold: null == defaultPrefetchThreshold
          ? _self.defaultPrefetchThreshold
          : defaultPrefetchThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      defaultPrefetchThresholdPixels: null == defaultPrefetchThresholdPixels
          ? _self.defaultPrefetchThresholdPixels
          : defaultPrefetchThresholdPixels // ignore: cast_nullable_to_non_nullable
              as double,
      maxRetries: null == maxRetries
          ? _self.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      initialBackoff: null == initialBackoff
          ? _self.initialBackoff
          : initialBackoff // ignore: cast_nullable_to_non_nullable
              as Duration,
      retryResetTimeout: null == retryResetTimeout
          ? _self.retryResetTimeout
          : retryResetTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      refreshDebounceDuration: null == refreshDebounceDuration
          ? _self.refreshDebounceDuration
          : refreshDebounceDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      searchDebounceDuration: null == searchDebounceDuration
          ? _self.searchDebounceDuration
          : searchDebounceDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// Adds pattern-matching-related methods to [PaginationOptions].
extension PaginationOptionsPatterns on PaginationOptions {
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
    TResult Function(_PaginationOptions value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaginationOptions() when $default != null:
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
    TResult Function(_PaginationOptions value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationOptions():
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
    TResult? Function(_PaginationOptions value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationOptions() when $default != null:
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
            int defaultPageSize,
            int maxPageSize,
            Duration requestTimeout,
            bool enableDebugLogging,
            int defaultPrefetchThreshold,
            double defaultPrefetchThresholdPixels,
            int maxRetries,
            Duration initialBackoff,
            Duration retryResetTimeout,
            Duration refreshDebounceDuration,
            Duration searchDebounceDuration)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaginationOptions() when $default != null:
        return $default(
            _that.defaultPageSize,
            _that.maxPageSize,
            _that.requestTimeout,
            _that.enableDebugLogging,
            _that.defaultPrefetchThreshold,
            _that.defaultPrefetchThresholdPixels,
            _that.maxRetries,
            _that.initialBackoff,
            _that.retryResetTimeout,
            _that.refreshDebounceDuration,
            _that.searchDebounceDuration);
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
            int defaultPageSize,
            int maxPageSize,
            Duration requestTimeout,
            bool enableDebugLogging,
            int defaultPrefetchThreshold,
            double defaultPrefetchThresholdPixels,
            int maxRetries,
            Duration initialBackoff,
            Duration retryResetTimeout,
            Duration refreshDebounceDuration,
            Duration searchDebounceDuration)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationOptions():
        return $default(
            _that.defaultPageSize,
            _that.maxPageSize,
            _that.requestTimeout,
            _that.enableDebugLogging,
            _that.defaultPrefetchThreshold,
            _that.defaultPrefetchThresholdPixels,
            _that.maxRetries,
            _that.initialBackoff,
            _that.retryResetTimeout,
            _that.refreshDebounceDuration,
            _that.searchDebounceDuration);
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
            int defaultPageSize,
            int maxPageSize,
            Duration requestTimeout,
            bool enableDebugLogging,
            int defaultPrefetchThreshold,
            double defaultPrefetchThresholdPixels,
            int maxRetries,
            Duration initialBackoff,
            Duration retryResetTimeout,
            Duration refreshDebounceDuration,
            Duration searchDebounceDuration)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationOptions() when $default != null:
        return $default(
            _that.defaultPageSize,
            _that.maxPageSize,
            _that.requestTimeout,
            _that.enableDebugLogging,
            _that.defaultPrefetchThreshold,
            _that.defaultPrefetchThresholdPixels,
            _that.maxRetries,
            _that.initialBackoff,
            _that.retryResetTimeout,
            _that.refreshDebounceDuration,
            _that.searchDebounceDuration);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PaginationOptions implements PaginationOptions {
  const _PaginationOptions(
      {this.defaultPageSize = PaginationDefaults.defaultPageSize,
      this.maxPageSize = PaginationDefaults.maxPageSize,
      this.requestTimeout = const Duration(
          seconds: PaginationDefaults.defaultRequestTimeoutSeconds),
      this.enableDebugLogging = false,
      this.defaultPrefetchThreshold =
          PaginationDefaults.defaultPrefetchThreshold,
      this.defaultPrefetchThresholdPixels =
          PaginationDefaults.defaultPrefetchThresholdPixels,
      this.maxRetries = PaginationDefaults.maxRetries,
      this.initialBackoff = const Duration(
          milliseconds: PaginationDefaults.defaultInitialBackoffMs),
      this.retryResetTimeout = const Duration(
          seconds: PaginationDefaults.defaultRetryResetTimeoutSeconds),
      this.refreshDebounceDuration = const Duration(
          milliseconds: PaginationDefaults.defaultRefreshDebounceMs),
      this.searchDebounceDuration = const Duration(
          milliseconds: PaginationDefaults.defaultSearchDebounceMs)});
  factory _PaginationOptions.fromJson(Map<String, dynamic> json) =>
      _$PaginationOptionsFromJson(json);

  /// Default page size
  @override
  @JsonKey()
  final int defaultPageSize;

  /// Maximum page size
  @override
  @JsonKey()
  final int maxPageSize;

  /// Request timeout
  @override
  @JsonKey()
  final Duration requestTimeout;

  /// Whether to enable debug logging
  @override
  @JsonKey()
  final bool enableDebugLogging;

  /// Default prefetch threshold (number of items from end to trigger load)
  @override
  @JsonKey()
  final int defaultPrefetchThreshold;

  /// Default prefetch threshold in pixels (if threshold is not set)
  @override
  @JsonKey()
  final double defaultPrefetchThresholdPixels;

  /// Maximum number of retry attempts
  @override
  @JsonKey()
  final int maxRetries;

  /// Initial backoff duration for retry attempts
  @override
  @JsonKey()
  final Duration initialBackoff;

  /// Retry reset timeout (resets retry count after this duration)
  @override
  @JsonKey()
  final Duration retryResetTimeout;

  /// Debounce duration for refresh calls to prevent rapid successive refreshes
  @override
  @JsonKey()
  final Duration refreshDebounceDuration;

  /// Debounce duration for search term updates to prevent excessive API calls
  /// while user is typing
  @override
  @JsonKey()
  final Duration searchDebounceDuration;

  /// Create a copy of PaginationOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PaginationOptionsCopyWith<_PaginationOptions> get copyWith =>
      __$PaginationOptionsCopyWithImpl<_PaginationOptions>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PaginationOptionsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PaginationOptions &&
            (identical(other.defaultPageSize, defaultPageSize) ||
                other.defaultPageSize == defaultPageSize) &&
            (identical(other.maxPageSize, maxPageSize) ||
                other.maxPageSize == maxPageSize) &&
            (identical(other.requestTimeout, requestTimeout) ||
                other.requestTimeout == requestTimeout) &&
            (identical(other.enableDebugLogging, enableDebugLogging) ||
                other.enableDebugLogging == enableDebugLogging) &&
            (identical(
                    other.defaultPrefetchThreshold, defaultPrefetchThreshold) ||
                other.defaultPrefetchThreshold == defaultPrefetchThreshold) &&
            (identical(other.defaultPrefetchThresholdPixels,
                    defaultPrefetchThresholdPixels) ||
                other.defaultPrefetchThresholdPixels ==
                    defaultPrefetchThresholdPixels) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.initialBackoff, initialBackoff) ||
                other.initialBackoff == initialBackoff) &&
            (identical(other.retryResetTimeout, retryResetTimeout) ||
                other.retryResetTimeout == retryResetTimeout) &&
            (identical(
                    other.refreshDebounceDuration, refreshDebounceDuration) ||
                other.refreshDebounceDuration == refreshDebounceDuration) &&
            (identical(other.searchDebounceDuration, searchDebounceDuration) ||
                other.searchDebounceDuration == searchDebounceDuration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      defaultPageSize,
      maxPageSize,
      requestTimeout,
      enableDebugLogging,
      defaultPrefetchThreshold,
      defaultPrefetchThresholdPixels,
      maxRetries,
      initialBackoff,
      retryResetTimeout,
      refreshDebounceDuration,
      searchDebounceDuration);

  @override
  String toString() {
    return 'PaginationOptions(defaultPageSize: $defaultPageSize, maxPageSize: $maxPageSize, requestTimeout: $requestTimeout, enableDebugLogging: $enableDebugLogging, defaultPrefetchThreshold: $defaultPrefetchThreshold, defaultPrefetchThresholdPixels: $defaultPrefetchThresholdPixels, maxRetries: $maxRetries, initialBackoff: $initialBackoff, retryResetTimeout: $retryResetTimeout, refreshDebounceDuration: $refreshDebounceDuration, searchDebounceDuration: $searchDebounceDuration)';
  }
}

/// @nodoc
abstract mixin class _$PaginationOptionsCopyWith<$Res>
    implements $PaginationOptionsCopyWith<$Res> {
  factory _$PaginationOptionsCopyWith(
          _PaginationOptions value, $Res Function(_PaginationOptions) _then) =
      __$PaginationOptionsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int defaultPageSize,
      int maxPageSize,
      Duration requestTimeout,
      bool enableDebugLogging,
      int defaultPrefetchThreshold,
      double defaultPrefetchThresholdPixels,
      int maxRetries,
      Duration initialBackoff,
      Duration retryResetTimeout,
      Duration refreshDebounceDuration,
      Duration searchDebounceDuration});
}

/// @nodoc
class __$PaginationOptionsCopyWithImpl<$Res>
    implements _$PaginationOptionsCopyWith<$Res> {
  __$PaginationOptionsCopyWithImpl(this._self, this._then);

  final _PaginationOptions _self;
  final $Res Function(_PaginationOptions) _then;

  /// Create a copy of PaginationOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? defaultPageSize = null,
    Object? maxPageSize = null,
    Object? requestTimeout = null,
    Object? enableDebugLogging = null,
    Object? defaultPrefetchThreshold = null,
    Object? defaultPrefetchThresholdPixels = null,
    Object? maxRetries = null,
    Object? initialBackoff = null,
    Object? retryResetTimeout = null,
    Object? refreshDebounceDuration = null,
    Object? searchDebounceDuration = null,
  }) {
    return _then(_PaginationOptions(
      defaultPageSize: null == defaultPageSize
          ? _self.defaultPageSize
          : defaultPageSize // ignore: cast_nullable_to_non_nullable
              as int,
      maxPageSize: null == maxPageSize
          ? _self.maxPageSize
          : maxPageSize // ignore: cast_nullable_to_non_nullable
              as int,
      requestTimeout: null == requestTimeout
          ? _self.requestTimeout
          : requestTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      enableDebugLogging: null == enableDebugLogging
          ? _self.enableDebugLogging
          : enableDebugLogging // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultPrefetchThreshold: null == defaultPrefetchThreshold
          ? _self.defaultPrefetchThreshold
          : defaultPrefetchThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      defaultPrefetchThresholdPixels: null == defaultPrefetchThresholdPixels
          ? _self.defaultPrefetchThresholdPixels
          : defaultPrefetchThresholdPixels // ignore: cast_nullable_to_non_nullable
              as double,
      maxRetries: null == maxRetries
          ? _self.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      initialBackoff: null == initialBackoff
          ? _self.initialBackoff
          : initialBackoff // ignore: cast_nullable_to_non_nullable
              as Duration,
      retryResetTimeout: null == retryResetTimeout
          ? _self.retryResetTimeout
          : retryResetTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      refreshDebounceDuration: null == refreshDebounceDuration
          ? _self.refreshDebounceDuration
          : refreshDebounceDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      searchDebounceDuration: null == searchDebounceDuration
          ? _self.searchDebounceDuration
          : searchDebounceDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

// dart format on
