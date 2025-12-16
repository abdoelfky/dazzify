import 'package:json_annotation/json_annotation.dart';

part 'get_services_request.g.dart';

@JsonSerializable()
class GetServicesRequest {
  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  @JsonKey(name: "mainCategory", includeIfNull: false)
  final String? mainCategory;

  const GetServicesRequest({
    required this.page,
    required this.limit,
    this.mainCategory,
  });

  factory GetServicesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetServicesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetServicesRequestToJson(this);
}
