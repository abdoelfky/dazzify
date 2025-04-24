import 'package:dazzify/core/util/time_manager.dart';
import 'package:dazzify/features/chat/data/models/content_content_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  @JsonKey(defaultValue: '')
  final String sender;

  @JsonKey(defaultValue: '')
  final String messageType;

  final MessageContentModel content;

  @JsonKey(defaultValue: '')
  final String createdAt;

  const MessageModel({
    required this.sender,
    required this.messageType,
    required this.content,
    required this.createdAt,
  });

  const MessageModel.empty({
    this.sender = '',
    this.messageType = '',
    this.content = const MessageContentModel.empty(),
    this.createdAt = '',
  });
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get messageSentTime => TimeManager.extractDate(createdAt);

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
