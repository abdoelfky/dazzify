// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_recommendation_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandRecommendationHistoryModel _$BrandRecommendationHistoryModelFromJson(
        Map<String, dynamic> json) =>
    BrandRecommendationHistoryModel(
      id: json['id'] as String,
      totalBudget: (json['totalBudget'] as num).toInt(),
      date: json['date'] as String,
      categoriesCount: (json['categoriesCount'] as num).toInt(),
      totalBrandsRecommended: (json['totalBrandsRecommended'] as num).toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$BrandRecommendationHistoryModelToJson(
        BrandRecommendationHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalBudget': instance.totalBudget,
      'date': instance.date,
      'categoriesCount': instance.categoriesCount,
      'totalBrandsRecommended': instance.totalBrandsRecommended,
      'createdAt': instance.createdAt,
    };
