// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationOptionsImpl _$$PaginationOptionsImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationOptionsImpl(
      defaultPageSize: (json['defaultPageSize'] as num?)?.toInt() ?? 20,
      maxPageSize: (json['maxPageSize'] as num?)?.toInt() ?? 100,
      requestTimeout: json['requestTimeout'] == null
          ? const Duration(seconds: 30)
          : Duration(microseconds: (json['requestTimeout'] as num).toInt()),
      enableDebugLogging: json['enableDebugLogging'] as bool? ?? false,
      defaultPrefetchThreshold:
          (json['defaultPrefetchThreshold'] as num?)?.toInt() ?? 3,
      defaultPrefetchThresholdPixels:
          (json['defaultPrefetchThresholdPixels'] as num?)?.toDouble() ?? 300.0,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 5,
      initialBackoff: json['initialBackoff'] == null
          ? const Duration(milliseconds: 500)
          : Duration(microseconds: (json['initialBackoff'] as num).toInt()),
      retryResetTimeout: json['retryResetTimeout'] == null
          ? const Duration(seconds: 60)
          : Duration(microseconds: (json['retryResetTimeout'] as num).toInt()),
      refreshDebounceDuration: json['refreshDebounceDuration'] == null
          ? const Duration(milliseconds: 300)
          : Duration(
              microseconds: (json['refreshDebounceDuration'] as num).toInt()),
    );

Map<String, dynamic> _$$PaginationOptionsImplToJson(
        _$PaginationOptionsImpl instance) =>
    <String, dynamic>{
      'defaultPageSize': instance.defaultPageSize,
      'maxPageSize': instance.maxPageSize,
      'requestTimeout': instance.requestTimeout.inMicroseconds,
      'enableDebugLogging': instance.enableDebugLogging,
      'defaultPrefetchThreshold': instance.defaultPrefetchThreshold,
      'defaultPrefetchThresholdPixels': instance.defaultPrefetchThresholdPixels,
      'maxRetries': instance.maxRetries,
      'initialBackoff': instance.initialBackoff.inMicroseconds,
      'retryResetTimeout': instance.retryResetTimeout.inMicroseconds,
      'refreshDebounceDuration':
          instance.refreshDebounceDuration.inMicroseconds,
    };
