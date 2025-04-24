import 'package:json_annotation/json_annotation.dart';

part 'content_content_model.g.dart';

@JsonSerializable()
class MessageContentModel {
  @JsonKey(defaultValue: '')
  final String? image;

  @JsonKey(defaultValue: '')
  final String? message;

  const MessageContentModel({
    required this.image,
    required this.message,
  });

  const MessageContentModel.empty({this.image = '', this.message = ''});

  factory MessageContentModel.fromJson(Map<String, dynamic> json) =>
      _$MessageContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageContentModelToJson(this);
}
