import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand_recommendation_model.g.dart';

@JsonSerializable()
class BrandRecommendationModel {
  final String id;
  final int totalBudget;
  final String date;
  final List<CategoryRecommendation> categories;
  final String createdAt;

  BrandRecommendationModel({
    required this.id,
    required this.totalBudget,
    required this.date,
    required this.categories,
    required this.createdAt,
  });

  factory BrandRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$BrandRecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandRecommendationModelToJson(this);
}

@JsonSerializable()
class CategoryRecommendation {
  final CategoryInfo category;
  final int weight;
  final int allocatedBudget;
  final List<RecommendedBrand> brands;

  CategoryRecommendation({
    required this.category,
    required this.weight,
    required this.allocatedBudget,
    required this.brands,
  });

  factory CategoryRecommendation.fromJson(Map<String, dynamic> json) =>
      _$CategoryRecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryRecommendationToJson(this);
}

@JsonSerializable()
class CategoryInfo {
  final String id;
  final String name;

  CategoryInfo({
    required this.id,
    required this.name,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) =>
      _$CategoryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryInfoToJson(this);
}

@JsonSerializable()
class RecommendedBrand {
  final String id;
  final String name;
  final String logo;
  final String slug;
  final int minPrice;
  final int maxPrice;
  final double rating;
  final int ratingCount;
  final bool verified;
  @JsonKey(name: 'hasAvailability')
  final bool hasAvailability;

  RecommendedBrand({
    required this.id,
    required this.name,
    required this.logo,
    required this.slug,
    required this.minPrice,
    required this.maxPrice,
    required this.rating,
    required this.ratingCount,
    required this.verified,
    required this.hasAvailability,
  });

  factory RecommendedBrand.fromJson(Map<String, dynamic> json) =>
      _$RecommendedBrandFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendedBrandToJson(this);

  // Convert to BrandModel for compatibility
  BrandModel toBrandModel() {
    return BrandModel(
      id: id,
      name: name,
      logo: logo,
      verified: verified,
      username: slug,
      description: '', // RecommendedBrand doesn't have description
      minPrice: minPrice,
      maxPrice: maxPrice,
      rating: rating,
      ratingCount: ratingCount,
      bannerUrl: '', // RecommendedBrand doesn't have bannerUrl
      allowMultipleServicesBook: false,
      refundConditions: const [],
    );
  }
}

