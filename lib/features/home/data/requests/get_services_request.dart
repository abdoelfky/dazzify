import 'package:json_annotation/json_annotation.dart';

part 'get_services_request.g.dart';

@JsonSerializable()
class GetServicesRequest {
  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  const GetServicesRequest({
    required this.page,
    required this.limit,
  });

  factory GetServicesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetServicesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetServicesRequestToJson(this);
}
