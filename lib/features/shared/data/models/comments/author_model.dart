import 'package:json_annotation/json_annotation.dart';

part 'author_model.g.dart';

@JsonSerializable()
class AuthorModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String type;
  @JsonKey(defaultValue: "")
  final String name;
  @JsonKey(defaultValue: "")
  final String picture;
  @JsonKey(defaultValue: "")
  final String deletedAt;
  @JsonKey(defaultValue: false)
  final bool verified;

  const AuthorModel.empty([
    this.deletedAt = '',
    this.id = '',
    this.name = '',
    this.picture = '',
    this.type = '',
    this.verified = false,
  ]);

  const AuthorModel({
    required this.id,
    required this.type,
    required this.name,
    required this.picture,
    required this.deletedAt,
    required this.verified,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}
