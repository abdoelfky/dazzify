import 'package:dazzify/features/brand/data/models/reviewer_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reviews_model.g.dart';

@JsonSerializable()
class ReviewModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: 0.0)
  final double rate;
  @JsonKey(defaultValue: "")
  final String comment;
  final ReviewerModel user;
  @JsonKey(defaultValue: false)
  final bool isLate;
  @JsonKey(defaultValue: "")
  final String createdAt;
  @JsonKey(defaultValue: "")
  final String updatedAt;

  const ReviewModel({
    required this.id,
    required this.rate,
    required this.comment,
    required this.user,
    required this.isLate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
