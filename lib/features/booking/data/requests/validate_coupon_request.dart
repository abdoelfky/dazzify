import 'package:json_annotation/json_annotation.dart';
import 'service_item_request.dart';

part 'validate_coupon_request.g.dart';

@JsonSerializable()
class ValidateCouponRequest {
  @JsonKey(name: "code")
  final String code;
  @JsonKey(name: "purchaseAmount")
  final num purchaseAmount;
  @JsonKey(name: "services")
  final List<ServiceItemRequest> services;

  const ValidateCouponRequest({
    required this.code,
    required this.purchaseAmount,
    required this.services,
  });

  factory ValidateCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$ValidateCouponRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ValidateCouponRequestToJson(this);
}
