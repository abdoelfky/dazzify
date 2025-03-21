// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_branches_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InBranchesModel _$InBranchesModelFromJson(Map<String, dynamic> json) =>
    InBranchesModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InBranchesModelToJson(InBranchesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location.toJson(),
    };
