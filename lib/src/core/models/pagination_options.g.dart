// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginationOptions _$PaginationOptionsFromJson(Map<String, dynamic> json) =>
    _PaginationOptions(
      defaultPageSize: (json['defaultPageSize'] as num?)?.toInt() ??
          PaginationDefaults.defaultPageSize,
      maxPageSize: (json['maxPageSize'] as num?)?.toInt() ??
          PaginationDefaults.maxPageSize,
      requestTimeout: json['requestTimeout'] == null
          ? const Duration(
              seconds: PaginationDefaults.defaultRequestTimeoutSeconds)
          : Duration(microseconds: (json['requestTimeout'] as num).toInt()),
      enableDebugLogging: json['enableDebugLogging'] as bool? ?? false,
      defaultPrefetchThreshold:
          (json['defaultPrefetchThreshold'] as num?)?.toInt() ??
              PaginationDefaults.defaultPrefetchThreshold,
      defaultPrefetchThresholdPixels:
          (json['defaultPrefetchThresholdPixels'] as num?)?.toDouble() ??
              PaginationDefaults.defaultPrefetchThresholdPixels,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ??
          PaginationDefaults.maxRetries,
      initialBackoff: json['initialBackoff'] == null
          ? const Duration(
              milliseconds: PaginationDefaults.defaultInitialBackoffMs)
          : Duration(microseconds: (json['initialBackoff'] as num).toInt()),
      retryResetTimeout: json['retryResetTimeout'] == null
          ? const Duration(
              seconds: PaginationDefaults.defaultRetryResetTimeoutSeconds)
          : Duration(microseconds: (json['retryResetTimeout'] as num).toInt()),
      refreshDebounceDuration: json['refreshDebounceDuration'] == null
          ? const Duration(
              milliseconds: PaginationDefaults.defaultRefreshDebounceMs)
          : Duration(
              microseconds: (json['refreshDebounceDuration'] as num).toInt()),
      searchDebounceDuration: json['searchDebounceDuration'] == null
          ? const Duration(
              milliseconds: PaginationDefaults.defaultSearchDebounceMs)
          : Duration(
              microseconds: (json['searchDebounceDuration'] as num).toInt()),
    );

Map<String, dynamic> _$PaginationOptionsToJson(_PaginationOptions instance) =>
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
      'searchDebounceDuration': instance.searchDebounceDuration.inMicroseconds,
    };
