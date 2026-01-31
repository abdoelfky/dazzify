// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_coupon_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateCouponRequest _$ValidateCouponRequestFromJson(
        Map<String, dynamic> json) =>
    ValidateCouponRequest(
      code: json['code'] as String,
      purchaseAmount: json['purchaseAmount'] as num,
      services: (json['services'] as List<dynamic>)
          .map((e) => ServiceItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ValidateCouponRequestToJson(
        ValidateCouponRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'purchaseAmount': instance.purchaseAmount,
      'services': instance.services.map((e) => e.toJson()).toList(),
    };
