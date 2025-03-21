// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_branches_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandBranchesModel _$BrandBranchesModelFromJson(Map<String, dynamic> json) =>
    BrandBranchesModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      isBusy: json['isBusy'] as bool? ?? false,
      chairsCount: (json['chairsCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BrandBranchesModelToJson(BrandBranchesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'isBusy': instance.isBusy,
      'chairsCount': instance.chairsCount,
    };
