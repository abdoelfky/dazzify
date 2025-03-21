// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => MediaModel(
      id: json['id'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      type: json['type'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      serviceId: json['service'] as String? ?? '',
      likesCount: (json['likesCount'] as num?)?.toInt(),
      viewsCount: (json['viewsCount'] as num?)?.toInt(),
      bookingsCount: (json['bookingsCount'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String? ?? '',
      brand: BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      commentsCount: (json['commentsCount'] as num?)?.toInt(),
      mediaItems: (json['mediaItems'] as List<dynamic>)
          .map((e) => MediaItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caption': instance.caption,
      'type': instance.type,
      'thumbnail': instance.thumbnail,
      'service': instance.serviceId,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'viewsCount': instance.viewsCount,
      'bookingsCount': instance.bookingsCount,
      'createdAt': instance.createdAt,
      'brand': instance.brand,
      'mediaItems': instance.mediaItems,
    };
