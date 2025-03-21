// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) => CouponModel(
      discountAmount: json['discountAmount'] as num? ?? 0,
      couponId: json['couponId'] as String? ?? '',
    );

Map<String, dynamic> _$CouponModelToJson(CouponModel instance) =>
    <String, dynamic>{
      'discountAmount': instance.discountAmount,
      'couponId': instance.couponId,
    };
