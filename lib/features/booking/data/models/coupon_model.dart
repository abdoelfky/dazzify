import 'package:json_annotation/json_annotation.dart';

part 'coupon_model.g.dart';

@JsonSerializable()
class CouponModel {
  @JsonKey(defaultValue: 0)
  final num discountAmount;

  @JsonKey(defaultValue: "")
  final String couponId;

  const CouponModel({
    required this.discountAmount,
    required this.couponId,
  });

  const CouponModel.empty([
    this.couponId = '',
    this.discountAmount = 0,
  ]);

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponModelToJson(this);
}
