// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: json['price'] as num? ?? 0,
      image: json['image'] as String? ?? '',
      mainCategory: json['mainCategory'] as String? ?? '',
      deletedAt: json['deletedAt'] as String? ?? '',
    );

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'image': instance.image,
      'mainCategory': instance.mainCategory,
      'deletedAt': instance.deletedAt,
    };
