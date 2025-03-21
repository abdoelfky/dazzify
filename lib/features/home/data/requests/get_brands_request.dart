import 'package:json_annotation/json_annotation.dart';

part 'get_brands_request.g.dart';

@JsonSerializable()
class GetBrandsRequest {
  @JsonKey(name: "keyword", includeIfNull: false)
  final String? keyword;

  @JsonKey(name: "mainCategory", includeIfNull: false)
  final String? mainCategory;

  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  const GetBrandsRequest({
    this.keyword,
    this.mainCategory,
    required this.page,
    required this.limit,
  });

  factory GetBrandsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBrandsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetBrandsRequestToJson(this);
}
