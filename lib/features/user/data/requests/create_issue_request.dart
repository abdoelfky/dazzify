import 'package:json_annotation/json_annotation.dart';

part 'create_issue_request.g.dart';

@JsonSerializable()
class CreateIssueRequest {
  @JsonKey(name: "bookingId")
  final String bookingId;

  @JsonKey(name: "comment")
  final String comment;

  const CreateIssueRequest({
    required this.bookingId,
    required this.comment,
  });

  factory CreateIssueRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateIssueRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateIssueRequestToJson(this);
}
