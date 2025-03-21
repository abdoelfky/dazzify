// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_reply_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddReplyRequest _$AddReplyRequestFromJson(Map<String, dynamic> json) =>
    AddReplyRequest(
      commentId: json['commentId'] as String,
      replyContent: json['replyContent'] as String,
    );

Map<String, dynamic> _$AddReplyRequestToJson(AddReplyRequest instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'replyContent': instance.replyContent,
    };
