import 'package:json_annotation/json_annotation.dart';

part 'get_brand_services_request.g.dart';

@JsonSerializable()
class GetBrandServicesRequest {
  @JsonKey(name: "branchId")
  final String branchId;

  const GetBrandServicesRequest({
    required this.branchId,
  });

  factory GetBrandServicesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBrandServicesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetBrandServicesRequestToJson(this);
}
