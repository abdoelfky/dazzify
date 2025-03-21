// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_comment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCommentRequest _$AddCommentRequestFromJson(Map<String, dynamic> json) =>
    AddCommentRequest(
      mediaId: json['mediaId'] as String,
      commentMessage: json['commentMessage'] as String,
    );

Map<String, dynamic> _$AddCommentRequestToJson(AddCommentRequest instance) =>
    <String, dynamic>{
      'mediaId': instance.mediaId,
      'commentMessage': instance.commentMessage,
    };
