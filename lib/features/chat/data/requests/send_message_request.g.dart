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

Map<String, dynamic> _$SendMessageRequestToJson(SendMessageRequest instance) {
  final val = <String, dynamic>{
    'branchId': instance.branchId,
    'messageType': instance.messageType,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content);
  writeNotNull('serviceId', instance.serviceId);
  return val;
}
