// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_meta_parser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MetaConfig _$MetaConfigFromJson(Map<String, dynamic> json) => _MetaConfig(
      itemsPath: json['itemsPath'] as String,
      pagePath: json['pagePath'] as String?,
      perPagePath: json['perPagePath'] as String?,
      totalPath: json['totalPath'] as String?,
      lastPagePath: json['lastPagePath'] as String?,
      hasMorePath: json['hasMorePath'] as String?,
      nextCursorPath: json['nextCursorPath'] as String?,
      previousCursorPath: json['previousCursorPath'] as String?,
      offsetPath: json['offsetPath'] as String?,
      limitPath: json['limitPath'] as String?,
    );

Map<String, dynamic> _$MetaConfigToJson(_MetaConfig instance) =>
    <String, dynamic>{
      'itemsPath': instance.itemsPath,
      'pagePath': instance.pagePath,
      'perPagePath': instance.perPagePath,
      'totalPath': instance.totalPath,
      'lastPagePath': instance.lastPagePath,
      'hasMorePath': instance.hasMorePath,
      'nextCursorPath': instance.nextCursorPath,
      'previousCursorPath': instance.previousCursorPath,
      'offsetPath': instance.offsetPath,
      'limitPath': instance.limitPath,
    };
