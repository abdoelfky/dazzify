import 'package:json_annotation/json_annotation.dart';

part 'validate_coupon_request.g.dart';

@JsonSerializable()
class ValidateCouponRequest {
  @JsonKey(name: "code")
  final String code;
  @JsonKey(name: "purchaseAmount")
  final num purchaseAmount;

  const ValidateCouponRequest({
    required this.code,
    required this.purchaseAmount,
  });

  factory ValidateCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$ValidateCouponRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ValidateCouponRequestToJson(this);
}
