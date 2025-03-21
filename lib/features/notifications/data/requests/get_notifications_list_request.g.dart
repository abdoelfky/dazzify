// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_notifications_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNotificationsListRequest _$GetNotificationsListRequestFromJson(
        Map<String, dynamic> json) =>
    GetNotificationsListRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetNotificationsListRequestToJson(
        GetNotificationsListRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
