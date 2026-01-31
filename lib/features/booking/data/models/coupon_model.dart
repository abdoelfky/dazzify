import 'package:json_annotation/json_annotation.dart';

part 'coupon_model.g.dart';

@JsonSerializable()
class CouponModel {
  @JsonKey(defaultValue: 0)
  final num discountAmount;

  @JsonKey(defaultValue: "")
  final String couponId;

  @JsonKey(defaultValue: "")
  final String message;

  const CouponModel({
    required this.discountAmount,
    required this.couponId,
    required this.message,
  });

  const CouponModel.empty([
    this.couponId = '',
    this.discountAmount = 0,
    this.message = '',
  ]);

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponModelToJson(this);
}
