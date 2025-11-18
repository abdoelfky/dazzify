// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiered_coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TieredCouponModel _$TieredCouponModelFromJson(Map<String, dynamic> json) =>
    TieredCouponModel(
      code: json['code'] as String?,
      opened: json['opened'] as bool? ?? false,
      locked: json['locked'] as bool? ?? true,
      levelNumber: (json['levelNumber'] as num?)?.toInt() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toInt() ?? 0,
      color: json['color'] == null
          ? null
          : CouponColorModel.fromJson(json['color'] as Map<String, dynamic>),
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$TieredCouponModelToJson(TieredCouponModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'opened': instance.opened,
      'locked': instance.locked,
      'levelNumber': instance.levelNumber,
      'discountPercentage': instance.discountPercentage,
      'color': instance.color,
      'instructions': instance.instructions,
    };
