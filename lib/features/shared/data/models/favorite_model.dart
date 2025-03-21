import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  @JsonKey(defaultValue: "")
  final String id;

  @JsonKey(defaultValue: "")
  final String title;

  @JsonKey(defaultValue: 0)
  final num price;

  @JsonKey(defaultValue: "")
  final String image;

  @JsonKey(defaultValue: "")
  final String mainCategory;

  @JsonKey(defaultValue: "")
  final String deletedAt;

  FavoriteModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.mainCategory,
    required this.deletedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);
}
