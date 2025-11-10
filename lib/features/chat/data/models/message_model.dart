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

  /// Local field to track message send status (not sent to/from API)
  /// Values: 'pending', 'uploading', 'sent', 'failed'
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? sendStatus;

  /// Local field to track upload progress (0.0 to 1.0)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double? uploadProgress;

  /// Local field to store temporary local file path before upload
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? localFilePath;

  const MessageModel({
    required this.sender,
    required this.messageType,
    required this.content,
    required this.createdAt,
    this.sendStatus,
    this.uploadProgress,
    this.localFilePath,
  });

  const MessageModel.empty({
    this.sender = '',
    this.messageType = '',
    this.content = const MessageContentModel.empty(),
    this.createdAt = '',
    this.sendStatus,
    this.uploadProgress,
    this.localFilePath,
  });
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get messageSentTime => TimeManager.extractDate(createdAt);

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  MessageModel copyWith({
    String? sender,
    String? messageType,
    MessageContentModel? content,
    String? createdAt,
    String? sendStatus,
    double? uploadProgress,
    String? localFilePath,
  }) {
    return MessageModel(
      sender: sender ?? this.sender,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      sendStatus: sendStatus ?? this.sendStatus,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      localFilePath: localFilePath ?? this.localFilePath,
    );
  }
}
