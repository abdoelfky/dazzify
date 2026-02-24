import 'package:json_annotation/json_annotation.dart';

part 'generate_brand_recommendation_request.g.dart';

@JsonSerializable()
class GenerateBrandRecommendationRequest {
  final int totalBudget;
  final String date;
  final List<CategoryWeight> categories;

  GenerateBrandRecommendationRequest({
    required this.totalBudget,
    required this.date,
    required this.categories,
  });

  factory GenerateBrandRecommendationRequest.fromJson(
          Map<String, dynamic> json) =>
      _$GenerateBrandRecommendationRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GenerateBrandRecommendationRequestToJson(this);
}

@JsonSerializable()
class CategoryWeight {
  @JsonKey(name: 'categoryId')
  final String categoryId;
  final int weight;

  CategoryWeight({
    required this.categoryId,
    required this.weight,
  });

  factory CategoryWeight.fromJson(Map<String, dynamic> json) =>
      _$CategoryWeightFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryWeightToJson(this);
}

