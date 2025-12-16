// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_services_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetServicesRequest _$GetServicesRequestFromJson(Map<String, dynamic> json) =>
    GetServicesRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      mainCategory: json['mainCategory'] as String?,
    );

Map<String, dynamic> _$GetServicesRequestToJson(GetServicesRequest instance) {
  final val = <String, dynamic>{
    'page': instance.page,
    'limit': instance.limit,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('mainCategory', instance.mainCategory);
  return val;
}
