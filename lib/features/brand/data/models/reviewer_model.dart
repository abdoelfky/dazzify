import 'package:json_annotation/json_annotation.dart';

part 'reviewer_model.g.dart';

@JsonSerializable()
class ReviewerModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String fullName;
  @JsonKey(defaultValue: "")
  final String profileImage;

  const ReviewerModel({
    required this.id,
    required this.fullName,
    required this.profileImage,
  });

  const ReviewerModel.empty({
    this.id = "",
    this.fullName = "",
    this.profileImage = "",
  });

  factory ReviewerModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewerModelToJson(this);
}
