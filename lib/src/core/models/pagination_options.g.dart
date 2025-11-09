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
    };
