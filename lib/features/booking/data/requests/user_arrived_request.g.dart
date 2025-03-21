// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_arrived_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserArrivedRequest _$UserArrivedRequestFromJson(Map<String, dynamic> json) =>
    UserArrivedRequest(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$UserArrivedRequestToJson(UserArrivedRequest instance) =>
    <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
