// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaItemsModel _$MediaItemsModelFromJson(Map<String, dynamic> json) =>
    MediaItemsModel(
      itemType: json['itemType'] as String? ?? '',
      itemUrl: json['itemUrl'] as String? ?? '',
    );

Map<String, dynamic> _$MediaItemsModelToJson(MediaItemsModel instance) =>
    <String, dynamic>{
      'itemType': instance.itemType,
      'itemUrl': instance.itemUrl,
    };
