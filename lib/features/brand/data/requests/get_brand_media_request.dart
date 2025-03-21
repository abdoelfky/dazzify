import 'package:json_annotation/json_annotation.dart';

part 'get_brand_media_request.g.dart';

@JsonSerializable()
class GetBrandMediaRequest {
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "limit")
  final int limit;
  @JsonKey(name: "brandId")
  final String brandId;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "sort")
  final String sort;

  const GetBrandMediaRequest({
    required this.page,
    required this.limit,
    required this.brandId,
    required this.type,
    this.sort = "-createdAt",
  });

  factory GetBrandMediaRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBrandMediaRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetBrandMediaRequestToJson(this);
}
