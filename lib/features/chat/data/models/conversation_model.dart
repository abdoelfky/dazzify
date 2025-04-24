// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:dazzify/features/chat/data/models/chat_branch_model.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel {
  final BrandModel brand;
  final ChatBranchModel branch;
  final MessageModel lastMessage;

  const ConversationModel({
    required this.brand,
    required this.branch,
    required this.lastMessage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);

  const ConversationModel.empty({
    this.brand = const BrandModel.empty(),
    this.branch = const ChatBranchModel.empty(),
    this.lastMessage = const MessageModel.empty(),
  });

  ConversationModel copyWith({
    BrandModel? brand,
    ChatBranchModel? branch,
    MessageModel? lastMessage,
  }) {
    return ConversationModel(
      brand: brand ?? this.brand,
      branch: branch ?? this.branch,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}
