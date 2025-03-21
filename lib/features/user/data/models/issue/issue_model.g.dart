// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueModel _$IssueModelFromJson(Map<String, dynamic> json) => IssueModel(
      issueId: json['issueId'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? '',
      services: (json['services'] as List<dynamic>)
          .map((e) => IssueService.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: (json['price'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      status: json['status'] as String? ?? '',
      reply: json['reply'] as String?,
    );

Map<String, dynamic> _$IssueModelToJson(IssueModel instance) =>
    <String, dynamic>{
      'issueId': instance.issueId,
      'bookingId': instance.bookingId,
      'services': instance.services,
      'price': instance.price,
      'comment': instance.comment,
      'status': instance.status,
      'reply': instance.reply,
    };
