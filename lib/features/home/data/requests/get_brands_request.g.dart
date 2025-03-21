// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brands_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBrandsRequest _$GetBrandsRequestFromJson(Map<String, dynamic> json) =>
    GetBrandsRequest(
      keyword: json['keyword'] as String?,
      mainCategory: json['mainCategory'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetBrandsRequestToJson(GetBrandsRequest instance) =>
    <String, dynamic>{
      if (instance.keyword case final value?) 'keyword': value,
      if (instance.mainCategory case final value?) 'mainCategory': value,
      'page': instance.page,
      'limit': instance.limit,
    };
