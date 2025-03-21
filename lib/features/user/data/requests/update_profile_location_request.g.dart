// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_location_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileLocationRequest _$UpdateProfileLocationRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateProfileLocationRequest(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$UpdateProfileLocationRequestToJson(
        UpdateProfileLocationRequest instance) =>
    <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
