// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchMessageModel _$BranchMessageModelFromJson(Map<String, dynamic> json) =>
    BranchMessageModel(
      branchId: json['branchId'] as String,
      message: MessageModel.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BranchMessageModelToJson(BranchMessageModel instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'message': instance.message,
    };
