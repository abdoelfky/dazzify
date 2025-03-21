// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandCategoriesModel _$BrandCategoriesModelFromJson(
        Map<String, dynamic> json) =>
    BrandCategoriesModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );

Map<String, dynamic> _$BrandCategoriesModelToJson(
        BrandCategoriesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
