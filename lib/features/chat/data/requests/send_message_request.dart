import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'send_message_request.g.dart';

@JsonSerializable()
class SendMessageRequest {
  @JsonKey(name: "branchId")
  final String branchId;

  @JsonKey(name: "messageType")
  final String messageType;

  @JsonKey(name: "content", includeIfNull: false)
  final String? content;

  @JsonKey(includeToJson: false, includeFromJson: false)
  final File? image;

  @JsonKey(name: "serviceId", includeIfNull: false)
  final String? serviceId;

  const SendMessageRequest({
    required this.branchId,
    required this.messageType,
    this.content,
    this.image,
    this.serviceId,
  });

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageRequestToJson(this);
}
