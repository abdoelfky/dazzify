// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_issue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateIssueRequest _$CreateIssueRequestFromJson(Map<String, dynamic> json) =>
    CreateIssueRequest(
      bookingId: json['bookingId'] as String,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$CreateIssueRequestToJson(CreateIssueRequest instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'comment': instance.comment,
    };
