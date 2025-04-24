// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatBranchModel _$ChatBranchModelFromJson(Map<String, dynamic> json) =>
    ChatBranchModel(
      branchId: json['id'] as String? ?? '',
      branchName: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$ChatBranchModelToJson(ChatBranchModel instance) =>
    <String, dynamic>{
      'id': instance.branchId,
      'name': instance.branchName,
    };
