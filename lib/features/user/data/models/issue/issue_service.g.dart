// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueService _$IssueServiceFromJson(Map<String, dynamic> json) => IssueService(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );

Map<String, dynamic> _$IssueServiceToJson(IssueService instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
