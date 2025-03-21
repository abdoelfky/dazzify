import 'package:dazzify/features/user/data/models/issue/issue_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_model.g.dart';

@JsonSerializable()
class IssueModel {
  @JsonKey(defaultValue: "")
  final String issueId;

  @JsonKey(defaultValue: "")
  final String bookingId;

  final List<IssueService> services;

  @JsonKey(defaultValue: 0)
  final int price;

  @JsonKey(defaultValue: "")
  final String comment;

  @JsonKey(defaultValue: "")
  String status;

  final String? reply;

  IssueModel({
    required this.issueId,
    required this.bookingId,
    required this.services,
    required this.price,
    required this.comment,
    required this.status,
    required this.reply,
  });

  IssueModel.empty({
    this.issueId = "",
    this.bookingId = "",
    this.services = const [],
    this.price = 0,
    this.comment = "",
    this.status = "",
    this.reply = "",
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) =>
      _$IssueModelFromJson(json);

  Map<String, dynamic> toJson() => _$IssueModelToJson(this);
}
