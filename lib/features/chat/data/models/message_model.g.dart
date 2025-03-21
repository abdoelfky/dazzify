// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      sender: json['sender'] as String? ?? '',
      messageType: json['messageType'] as String? ?? '',
      content:
          MessageContentModel.fromJson(json['content'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'messageType': instance.messageType,
      'content': instance.content,
      'createdAt': instance.createdAt,
    };
