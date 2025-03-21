import 'package:json_annotation/json_annotation.dart';

part 'get_issues_request.g.dart';

@JsonSerializable()
class GetIssuesRequest {
  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  const GetIssuesRequest({
    required this.page,
    required this.limit,
  });

  factory GetIssuesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetIssuesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetIssuesRequestToJson(this);
}
