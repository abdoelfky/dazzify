import 'package:dazzify/features/user/data/models/tiered_coupon/coupon_color_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tiered_coupon_model.g.dart';

@JsonSerializable()
class TieredCouponModel {
  @JsonKey(defaultValue: null)
  final String? code;

  @JsonKey(defaultValue: false)
  final bool opened;

  @JsonKey(defaultValue: true)
  final bool locked;

  @JsonKey(defaultValue: 0)
  final int levelNumber;

  @JsonKey(defaultValue: 0)
  final int discountPercentage;

  @JsonKey(defaultValue: null)
  final CouponColorModel? color;

  @JsonKey(defaultValue: [])
  final List<String> instructions;

  const TieredCouponModel({
    this.code,
    required this.opened,
    required this.locked,
    required this.levelNumber,
    required this.discountPercentage,
    this.color,
    required this.instructions,
  });

  const TieredCouponModel.empty([
    this.code = null,
    this.opened = false,
    this.locked = true,
    this.levelNumber = 0,
    this.discountPercentage = 0,
    this.color = const CouponColorModel.empty(),
    this.instructions = const [],
  ]);

  factory TieredCouponModel.fromJson(Map<String, dynamic> json) =>
      _$TieredCouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$TieredCouponModelToJson(this);

  TieredCouponModel copyWith({
    String? code,
    bool? opened,
    bool? locked,
    int? levelNumber,
    int? discountPercentage,
    CouponColorModel? color,
    List<String>? instructions,
  }) {
    return TieredCouponModel(
      code: code ?? this.code,
      opened: opened ?? this.opened,
      locked: locked ?? this.locked,
      levelNumber: levelNumber ?? this.levelNumber,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      color: color ?? this.color,
      instructions: instructions ?? this.instructions,
    );
  }
}
