import 'package:json_annotation/json_annotation.dart';

part 'get_brand_slots_request.g.dart';

@JsonSerializable()
class GetBrandSlotsRequest {
  @JsonKey(name: "branchId")
  final String? branchId;
  @JsonKey(name: "serviceId", includeIfNull: false)
  final String? serviceId;
  @JsonKey(name: "services", includeIfNull: false)
  final List<String>? services;
  @JsonKey(name: "month")
  final int month;
  @JsonKey(name: "year")
  final int year;

  const GetBrandSlotsRequest({
    required this.branchId,
    this.serviceId,
    this.services,
    required this.month,
    required this.year,
  });

  factory GetBrandSlotsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBrandSlotsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetBrandSlotsRequestToJson(this);
}
