import 'package:json_annotation/json_annotation.dart';

part 'issue_service.g.dart';

@JsonSerializable()
class IssueService {
  @JsonKey(defaultValue: "")
  final String title;
  @JsonKey(defaultValue: "")
  final String description;
  @JsonKey(defaultValue: "")
  final String image;

  IssueService({
    required this.title,
    required this.description,
    required this.image,
  });

  const IssueService.empty({
    this.title = "",
    this.description = "",
    this.image = "",
  });

  factory IssueService.fromJson(Map<String, dynamic> json) =>
      _$IssueServiceFromJson(json);

  Map<String, dynamic> toJson() => _$IssueServiceToJson(this);
}
