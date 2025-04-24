// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageContentModel _$MessageContentModelFromJson(Map<String, dynamic> json) =>
    MessageContentModel(
      image: json['image'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$MessageContentModelToJson(
        MessageContentModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'message': instance.message,
    };
