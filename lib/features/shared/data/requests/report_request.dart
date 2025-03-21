import 'package:json_annotation/json_annotation.dart';

part 'report_request.g.dart';

@JsonSerializable()
class ReportRequest {
  String type;
  String description;
  @JsonKey(name: "reportTargetId")
  String id;

  ReportRequest({
    this.type = "",
    this.description = "",
    this.id = "",
  });

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRequestToJson(this);
}
