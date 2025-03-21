// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceLocationModel _$ServiceLocationModelFromJson(
        Map<String, dynamic> json) =>
    ServiceLocationModel(
      name: json['name'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$ServiceLocationModelToJson(
        ServiceLocationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'id': instance.id,
    };
