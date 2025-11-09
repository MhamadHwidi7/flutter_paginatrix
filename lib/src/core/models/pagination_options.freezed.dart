// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginationOptions _$PaginationOptionsFromJson(Map<String, dynamic> json) {
  return _PaginationOptions.fromJson(json);
}

/// @nodoc
mixin _$PaginationOptions {
  /// Default page size
  int get defaultPageSize => throw _privateConstructorUsedError;

  /// Maximum page size
  int get maxPageSize => throw _privateConstructorUsedError;

  /// Request timeout
  Duration get requestTimeout => throw _privateConstructorUsedError;

  /// Whether to enable debug logging
  bool get enableDebugLogging => throw _privateConstructorUsedError;

  /// Default prefetch threshold (number of items from end to trigger load)
  int get defaultPrefetchThreshold => throw _privateConstructorUsedError;

  /// Default prefetch threshold in pixels (if threshold is not set)
  double get defaultPrefetchThresholdPixels =>
      throw _privateConstructorUsedError;

  /// Maximum number of retry attempts
  int get maxRetries => throw _privateConstructorUsedError;

  /// Initial backoff duration for retry attempts
  Duration get initialBackoff => throw _privateConstructorUsedError;

  /// Retry reset timeout (resets retry count after this duration)
  Duration get retryResetTimeout => throw _privateConstructorUsedError;

  /// Debounce duration for refresh calls to prevent rapid successive refreshes
  Duration get refreshDebounceDuration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationOptionsCopyWith<PaginationOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationOptionsCopyWith<$Res> {
  factory $PaginationOptionsCopyWith(
          PaginationOptions value, $Res Function(PaginationOptions) then) =
      _$PaginationOptionsCopyWithImpl<$Res, PaginationOptions>;
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
      Duration refreshDebounceDuration});
}

/// @nodoc
class _$PaginationOptionsCopyWithImpl<$Res, $Val extends PaginationOptions>
    implements $PaginationOptionsCopyWith<$Res> {
  _$PaginationOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
  }) {
    return _then(_value.copyWith(
      defaultPageSize: null == defaultPageSize
          ? _value.defaultPageSize
          : defaultPageSize // ignore: cast_nullable_to_non_nullable
              as int,
      maxPageSize: null == maxPageSize
          ? _value.maxPageSize
          : maxPageSize // ignore: cast_nullable_to_non_nullable
              as int,
      requestTimeout: null == requestTimeout
          ? _value.requestTimeout
          : requestTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      enableDebugLogging: null == enableDebugLogging
          ? _value.enableDebugLogging
          : enableDebugLogging // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultPrefetchThreshold: null == defaultPrefetchThreshold
          ? _value.defaultPrefetchThreshold
          : defaultPrefetchThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      defaultPrefetchThresholdPixels: null == defaultPrefetchThresholdPixels
          ? _value.defaultPrefetchThresholdPixels
          : defaultPrefetchThresholdPixels // ignore: cast_nullable_to_non_nullable
              as double,
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      initialBackoff: null == initialBackoff
          ? _value.initialBackoff
          : initialBackoff // ignore: cast_nullable_to_non_nullable
              as Duration,
      retryResetTimeout: null == retryResetTimeout
          ? _value.retryResetTimeout
          : retryResetTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      refreshDebounceDuration: null == refreshDebounceDuration
          ? _value.refreshDebounceDuration
          : refreshDebounceDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationOptionsImplCopyWith<$Res>
    implements $PaginationOptionsCopyWith<$Res> {
  factory _$$PaginationOptionsImplCopyWith(_$PaginationOptionsImpl value,
          $Res Function(_$PaginationOptionsImpl) then) =
      __$$PaginationOptionsImplCopyWithImpl<$Res>;
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
      Duration refreshDebounceDuration});
}

/// @nodoc
class __$$PaginationOptionsImplCopyWithImpl<$Res>
    extends _$PaginationOptionsCopyWithImpl<$Res, _$PaginationOptionsImpl>
    implements _$$PaginationOptionsImplCopyWith<$Res> {
  __$$PaginationOptionsImplCopyWithImpl(_$PaginationOptionsImpl _value,
      $Res Function(_$PaginationOptionsImpl) _then)
      : super(_value, _then);

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
  }) {
    return _then(_$PaginationOptionsImpl(
      defaultPageSize: null == defaultPageSize
          ? _value.defaultPageSize
          : defaultPageSize // ignore: cast_nullable_to_non_nullable
              as int,
      maxPageSize: null == maxPageSize
          ? _value.maxPageSize
          : maxPageSize // ignore: cast_nullable_to_non_nullable
              as int,
      requestTimeout: null == requestTimeout
          ? _value.requestTimeout
          : requestTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      enableDebugLogging: null == enableDebugLogging
          ? _value.enableDebugLogging
          : enableDebugLogging // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultPrefetchThreshold: null == defaultPrefetchThreshold
          ? _value.defaultPrefetchThreshold
          : defaultPrefetchThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      defaultPrefetchThresholdPixels: null == defaultPrefetchThresholdPixels
          ? _value.defaultPrefetchThresholdPixels
          : defaultPrefetchThresholdPixels // ignore: cast_nullable_to_non_nullable
              as double,
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      initialBackoff: null == initialBackoff
          ? _value.initialBackoff
          : initialBackoff // ignore: cast_nullable_to_non_nullable
              as Duration,
      retryResetTimeout: null == retryResetTimeout
          ? _value.retryResetTimeout
          : retryResetTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      refreshDebounceDuration: null == refreshDebounceDuration
          ? _value.refreshDebounceDuration
          : refreshDebounceDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationOptionsImpl implements _PaginationOptions {
  const _$PaginationOptionsImpl(
      {this.defaultPageSize = 20,
      this.maxPageSize = 100,
      this.requestTimeout = const Duration(seconds: 30),
      this.enableDebugLogging = false,
      this.defaultPrefetchThreshold = 3,
      this.defaultPrefetchThresholdPixels = 300.0,
      this.maxRetries = 5,
      this.initialBackoff = const Duration(milliseconds: 500),
      this.retryResetTimeout = const Duration(seconds: 60),
      this.refreshDebounceDuration = const Duration(milliseconds: 300)});

  factory _$PaginationOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationOptionsImplFromJson(json);

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

  @override
  String toString() {
    return 'PaginationOptions(defaultPageSize: $defaultPageSize, maxPageSize: $maxPageSize, requestTimeout: $requestTimeout, enableDebugLogging: $enableDebugLogging, defaultPrefetchThreshold: $defaultPrefetchThreshold, defaultPrefetchThresholdPixels: $defaultPrefetchThresholdPixels, maxRetries: $maxRetries, initialBackoff: $initialBackoff, retryResetTimeout: $retryResetTimeout, refreshDebounceDuration: $refreshDebounceDuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationOptionsImpl &&
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
                other.refreshDebounceDuration == refreshDebounceDuration));
  }

  @JsonKey(ignore: true)
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
      refreshDebounceDuration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationOptionsImplCopyWith<_$PaginationOptionsImpl> get copyWith =>
      __$$PaginationOptionsImplCopyWithImpl<_$PaginationOptionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationOptionsImplToJson(
      this,
    );
  }
}

abstract class _PaginationOptions implements PaginationOptions {
  const factory _PaginationOptions(
      {final int defaultPageSize,
      final int maxPageSize,
      final Duration requestTimeout,
      final bool enableDebugLogging,
      final int defaultPrefetchThreshold,
      final double defaultPrefetchThresholdPixels,
      final int maxRetries,
      final Duration initialBackoff,
      final Duration retryResetTimeout,
      final Duration refreshDebounceDuration}) = _$PaginationOptionsImpl;

  factory _PaginationOptions.fromJson(Map<String, dynamic> json) =
      _$PaginationOptionsImpl.fromJson;

  @override

  /// Default page size
  int get defaultPageSize;
  @override

  /// Maximum page size
  int get maxPageSize;
  @override

  /// Request timeout
  Duration get requestTimeout;
  @override

  /// Whether to enable debug logging
  bool get enableDebugLogging;
  @override

  /// Default prefetch threshold (number of items from end to trigger load)
  int get defaultPrefetchThreshold;
  @override

  /// Default prefetch threshold in pixels (if threshold is not set)
  double get defaultPrefetchThresholdPixels;
  @override

  /// Maximum number of retry attempts
  int get maxRetries;
  @override

  /// Initial backoff duration for retry attempts
  Duration get initialBackoff;
  @override

  /// Retry reset timeout (resets retry count after this duration)
  Duration get retryResetTimeout;
  @override

  /// Debounce duration for refresh calls to prevent rapid successive refreshes
  Duration get refreshDebounceDuration;
  @override
  @JsonKey(ignore: true)
  _$$PaginationOptionsImplCopyWith<_$PaginationOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
