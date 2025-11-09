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
      double defaultPrefetchThresholdPixels});
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
      double defaultPrefetchThresholdPixels});
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
      this.defaultPrefetchThresholdPixels = 300.0});

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

  @override
  String toString() {
    return 'PaginationOptions(defaultPageSize: $defaultPageSize, maxPageSize: $maxPageSize, requestTimeout: $requestTimeout, enableDebugLogging: $enableDebugLogging, defaultPrefetchThreshold: $defaultPrefetchThreshold, defaultPrefetchThresholdPixels: $defaultPrefetchThresholdPixels)';
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
                    defaultPrefetchThresholdPixels));
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
      defaultPrefetchThresholdPixels);

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
      final double defaultPrefetchThresholdPixels}) = _$PaginationOptionsImpl;

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
  @JsonKey(ignore: true)
  _$$PaginationOptionsImplCopyWith<_$PaginationOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
