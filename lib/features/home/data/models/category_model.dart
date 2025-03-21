import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String name;
  @JsonKey(defaultValue: "")
  final String image;

  const CategoryModel.empty({
    this.id = "",
    this.name = "",
    this.image = "",
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
