import 'package:json_annotation/json_annotation.dart';

part 'get_brand_reviews_request.g.dart';

@JsonSerializable()
class GetBrandReviewsRequest {
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "limit")
  final int limit;

  const GetBrandReviewsRequest({
    required this.page,
    required this.limit,
  });

  factory GetBrandReviewsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBrandReviewsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetBrandReviewsRequestToJson(this);
}
