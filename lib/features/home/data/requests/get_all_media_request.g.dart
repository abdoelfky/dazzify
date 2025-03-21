// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_media_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllMediaRequest _$GetAllMediaRequestFromJson(Map<String, dynamic> json) =>
    GetAllMediaRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetAllMediaRequestToJson(GetAllMediaRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
