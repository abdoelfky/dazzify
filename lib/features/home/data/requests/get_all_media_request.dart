import 'package:json_annotation/json_annotation.dart';

part 'get_all_media_request.g.dart';

@JsonSerializable()
class GetAllMediaRequest {
  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  const GetAllMediaRequest({
    required this.page,
    required this.limit,
  });

  factory GetAllMediaRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAllMediaRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllMediaRequestToJson(this);
}
