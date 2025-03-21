import 'package:dazzify/features/shared/data/models/comments/author_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String content;
  @JsonKey(defaultValue: "")
  final String createdAt;
  @JsonKey(defaultValue: "")
  final String editedAt;
  @JsonKey(defaultValue: 0)
  int likesCount;
  final AuthorModel author;
  @JsonKey(defaultValue: [])
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.editedAt,
    required this.likesCount,
    required this.author,
    required this.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
