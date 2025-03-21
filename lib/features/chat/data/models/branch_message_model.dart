import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch_message_model.g.dart';

@JsonSerializable()
class BranchMessageModel {
  final String branchId;
  final MessageModel message;

  BranchMessageModel({
    required this.branchId,
    required this.message,
  });

  const BranchMessageModel.empty({
    required this.branchId,
    required this.message,
  });

  factory BranchMessageModel.fromJson(Map<String, dynamic> json) =>
      _$BranchMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchMessageModelToJson(this);
}
