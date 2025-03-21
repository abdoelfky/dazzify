// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchInfoModel _$BranchInfoModelFromJson(Map<String, dynamic> json) =>
    BranchInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$BranchInfoModelToJson(BranchInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
