import 'package:json_annotation/json_annotation.dart';

part 'chat_branch_model.g.dart';

@JsonSerializable()
class ChatBranchModel {
  @JsonKey(name: 'id', defaultValue: '')
  final String branchId;

  @JsonKey(name: 'name', defaultValue: '')
  final String branchName;

  const ChatBranchModel({
    required this.branchId,
    required this.branchName,
  });

  const ChatBranchModel.empty({
    this.branchId = '',
    this.branchName = '',
  });

  factory ChatBranchModel.fromJson(Map<String, dynamic> json) =>
      _$ChatBranchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatBranchModelToJson(this);
}
