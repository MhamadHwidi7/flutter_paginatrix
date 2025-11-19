// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageMeta _$PageMetaFromJson(Map<String, dynamic> json) => _PageMeta(
      page: (json['page'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      lastPage: (json['lastPage'] as num?)?.toInt(),
      hasMore: json['hasMore'] as bool?,
      nextCursor: json['nextCursor'] as String?,
      previousCursor: json['previousCursor'] as String?,
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PageMetaToJson(_PageMeta instance) => <String, dynamic>{
      'page': instance.page,
      'perPage': instance.perPage,
      'total': instance.total,
      'lastPage': instance.lastPage,
      'hasMore': instance.hasMore,
      'nextCursor': instance.nextCursor,
      'previousCursor': instance.previousCursor,
      'offset': instance.offset,
      'limit': instance.limit,
    };
