// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) =>
    SendMessageRequest(
      branchId: json['branchId'] as String,
      messageType: json['messageType'] as String,
      content: json['content'] as String?,
      serviceId: json['serviceId'] as String?,
    );

Map<String, dynamic> _$SendMessageRequestToJson(SendMessageRequest instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'messageType': instance.messageType,
      if (instance.content case final value?) 'content': value,
      if (instance.serviceId case final value?) 'serviceId': value,
    };
