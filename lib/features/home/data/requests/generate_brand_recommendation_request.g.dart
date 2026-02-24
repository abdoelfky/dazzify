// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_brand_recommendation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateBrandRecommendationRequest _$GenerateBrandRecommendationRequestFromJson(
        Map<String, dynamic> json) =>
    GenerateBrandRecommendationRequest(
      totalBudget: (json['totalBudget'] as num).toInt(),
      date: json['date'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryWeight.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenerateBrandRecommendationRequestToJson(
        GenerateBrandRecommendationRequest instance) =>
    <String, dynamic>{
      'totalBudget': instance.totalBudget,
      'date': instance.date,
      'categories': instance.categories,
    };

CategoryWeight _$CategoryWeightFromJson(Map<String, dynamic> json) =>
    CategoryWeight(
      categoryId: json['categoryId'] as String,
      weight: (json['weight'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryWeightToJson(CategoryWeight instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'weight': instance.weight,
    };
