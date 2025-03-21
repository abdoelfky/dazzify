// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brand_media_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBrandMediaRequest _$GetBrandMediaRequestFromJson(
        Map<String, dynamic> json) =>
    GetBrandMediaRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      brandId: json['brandId'] as String,
      type: json['type'] as String,
      sort: json['sort'] as String? ?? "-createdAt",
    );

Map<String, dynamic> _$GetBrandMediaRequestToJson(
        GetBrandMediaRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'brandId': instance.brandId,
      'type': instance.type,
      'sort': instance.sort,
    };
