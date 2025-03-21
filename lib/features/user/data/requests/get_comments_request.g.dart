// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_comments_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCommentsRequest _$GetCommentsRequestFromJson(Map<String, dynamic> json) =>
    GetCommentsRequest(
      mediaId: json['mediaId'] as String,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetCommentsRequestToJson(GetCommentsRequest instance) =>
    <String, dynamic>{
      'mediaId': instance.mediaId,
      'page': instance.page,
      'limit': instance.limit,
    };
