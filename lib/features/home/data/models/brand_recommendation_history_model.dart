import 'package:json_annotation/json_annotation.dart';

part 'brand_recommendation_history_model.g.dart';

@JsonSerializable()
class BrandRecommendationHistoryModel {
  final String id;
  final int totalBudget;
  final String date;
  final int categoriesCount;
  final int totalBrandsRecommended;
  final String createdAt;

  BrandRecommendationHistoryModel({
    required this.id,
    required this.totalBudget,
    required this.date,
    required this.categoriesCount,
    required this.totalBrandsRecommended,
    required this.createdAt,
  });

  factory BrandRecommendationHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$BrandRecommendationHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandRecommendationHistoryModelToJson(this);
}

