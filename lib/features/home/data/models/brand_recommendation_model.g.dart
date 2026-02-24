// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandRecommendationModel _$BrandRecommendationModelFromJson(
        Map<String, dynamic> json) =>
    BrandRecommendationModel(
      id: json['id'] as String,
      totalBudget: (json['totalBudget'] as num).toInt(),
      date: json['date'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map(
              (e) => CategoryRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$BrandRecommendationModelToJson(
        BrandRecommendationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalBudget': instance.totalBudget,
      'date': instance.date,
      'categories': instance.categories,
      'createdAt': instance.createdAt,
    };

CategoryRecommendation _$CategoryRecommendationFromJson(
        Map<String, dynamic> json) =>
    CategoryRecommendation(
      category: CategoryInfo.fromJson(json['category'] as Map<String, dynamic>),
      weight: (json['weight'] as num).toInt(),
      allocatedBudget: (json['allocatedBudget'] as num).toInt(),
      brands: (json['brands'] as List<dynamic>)
          .map((e) => RecommendedBrand.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryRecommendationToJson(
        CategoryRecommendation instance) =>
    <String, dynamic>{
      'category': instance.category,
      'weight': instance.weight,
      'allocatedBudget': instance.allocatedBudget,
      'brands': instance.brands,
    };

CategoryInfo _$CategoryInfoFromJson(Map<String, dynamic> json) => CategoryInfo(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryInfoToJson(CategoryInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

RecommendedBrand _$RecommendedBrandFromJson(Map<String, dynamic> json) =>
    RecommendedBrand(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String,
      slug: json['slug'] as String,
      minPrice: (json['minPrice'] as num).toInt(),
      maxPrice: (json['maxPrice'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      ratingCount: (json['ratingCount'] as num).toInt(),
      verified: json['verified'] as bool,
      hasAvailability: json['hasAvailability'] as bool,
    );

Map<String, dynamic> _$RecommendedBrandToJson(RecommendedBrand instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'slug': instance.slug,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'verified': instance.verified,
      'hasAvailability': instance.hasAvailability,
    };
