import 'package:json_annotation/json_annotation.dart';

part 'update_comment_request.g.dart';

@JsonSerializable()
class UpdateCommentRequest {
  @JsonKey(name: 'commentId')
  final String commentId;

  @JsonKey(name: 'content')
  final String content;

  const UpdateCommentRequest({
    required this.commentId,
    required this.content,
  });

  factory UpdateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCommentRequestToJson(this);
}
