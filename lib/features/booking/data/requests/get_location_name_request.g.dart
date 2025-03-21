// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_location_name_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetLocationNameRequest _$GetLocationNameRequestFromJson(
        Map<String, dynamic> json) =>
    GetLocationNameRequest(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$GetLocationNameRequestToJson(
        GetLocationNameRequest instance) =>
    <String, dynamic>{
      'lat': instance.latitude,
      'lng': instance.longitude,
    };
