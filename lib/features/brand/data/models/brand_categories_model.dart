import 'package:json_annotation/json_annotation.dart';

part 'brand_categories_model.g.dart';

@JsonSerializable()
class BrandCategoriesModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String name;
  @JsonKey(defaultValue: "")
  final String image;

  BrandCategoriesModel({
    required this.id,
    required this.name,
    required this.image,
  });

  const BrandCategoriesModel.empty([
    this.id = '',
    this.name = '',
    this.image = '',
  ]);

  factory BrandCategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$BrandCategoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandCategoriesModelToJson(this);
}
