import 'package:json_annotation/json_annotation.dart';

part 'get_service_review_request.g.dart';

@JsonSerializable()
class GetServiceReviewRequest {
  @JsonKey(name: "serviceId")
  final String serviceId;

  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  const GetServiceReviewRequest({
    required this.serviceId,
    required this.page,
    required this.limit,
  });

  factory GetServiceReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$GetServiceReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetServiceReviewRequestToJson(this);
}
