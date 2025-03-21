// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportRequest _$ReportRequestFromJson(Map<String, dynamic> json) =>
    ReportRequest(
      type: json['type'] as String? ?? "",
      description: json['description'] as String? ?? "",
      id: json['reportTargetId'] as String? ?? "",
    );

Map<String, dynamic> _$ReportRequestToJson(ReportRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'reportTargetId': instance.id,
    };
