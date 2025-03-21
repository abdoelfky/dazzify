// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      brand: BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      branch: ChatBranchModel.fromJson(json['branch'] as Map<String, dynamic>),
      lastMessage:
          MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'branch': instance.branch,
      'lastMessage': instance.lastMessage,
    };
