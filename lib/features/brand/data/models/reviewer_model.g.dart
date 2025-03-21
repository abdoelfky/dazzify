// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviewer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewerModel _$ReviewerModelFromJson(Map<String, dynamic> json) =>
    ReviewerModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
    );

Map<String, dynamic> _$ReviewerModelToJson(ReviewerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'profileImage': instance.profileImage,
    };
