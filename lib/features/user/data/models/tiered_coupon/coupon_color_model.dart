import 'package:json_annotation/json_annotation.dart';

part 'coupon_color_model.g.dart';

@JsonSerializable()
class CouponColorModel {
  @JsonKey(defaultValue: "#FFFFFF")
  final String sideBackground;

  @JsonKey(defaultValue: "#FFFFFF")
  final String bodyBackground;

  const CouponColorModel({
    required this.sideBackground,
    required this.bodyBackground,
  });

  const CouponColorModel.empty([
    this.sideBackground = '#FFFFFF',
    this.bodyBackground = '#FFFFFF',
  ]);

  factory CouponColorModel.fromJson(Map<String, dynamic> json) =>
      _$CouponColorModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponColorModelToJson(this);
}
