// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_services_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetServicesRequest _$GetServicesRequestFromJson(Map<String, dynamic> json) =>
    GetServicesRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetServicesRequestToJson(GetServicesRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
