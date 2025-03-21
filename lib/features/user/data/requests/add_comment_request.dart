import 'package:json_annotation/json_annotation.dart';

part 'add_comment_request.g.dart';

@JsonSerializable()
class AddCommentRequest {
  @JsonKey(name: "mediaId")
  final String mediaId;

  @JsonKey(name: "commentMessage")
  final String commentMessage;

  const AddCommentRequest({
    required this.mediaId,
    required this.commentMessage,
  });

  factory AddCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddCommentRequestToJson(this);
}
