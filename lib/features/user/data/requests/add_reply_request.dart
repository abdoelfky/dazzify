import 'package:json_annotation/json_annotation.dart';

part 'add_reply_request.g.dart';

@JsonSerializable()
class AddReplyRequest {
  @JsonKey(name: "commentId")
  final String commentId;

  @JsonKey(name: "replyContent")
  final String replyContent;

  const AddReplyRequest({
    required this.commentId,
    required this.replyContent,
  });

  factory AddReplyRequest.fromJson(Map<String, dynamic> json) =>
      _$AddReplyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddReplyRequestToJson(this);
}
