// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_issues_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetIssuesRequest _$GetIssuesRequestFromJson(Map<String, dynamic> json) =>
    GetIssuesRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetIssuesRequestToJson(GetIssuesRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
