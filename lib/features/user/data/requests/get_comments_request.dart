import 'package:json_annotation/json_annotation.dart';

part 'get_comments_request.g.dart';

@JsonSerializable()
class GetCommentsRequest {
  @JsonKey(name: "mediaId")
  final String mediaId;

  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  const GetCommentsRequest({
    required this.mediaId,
    required this.page,
    required this.limit,
  });

  factory GetCommentsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetCommentsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetCommentsRequestToJson(this);
}
