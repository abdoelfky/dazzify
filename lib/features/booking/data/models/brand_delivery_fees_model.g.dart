// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_delivery_fees_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandDeliveryFeesModel _$BrandDeliveryFeesModelFromJson(
        Map<String, dynamic> json) =>
    BrandDeliveryFeesModel(
      gov: (json['gov'] as num?)?.toInt() ?? 0,
      deliveryFees: json['deliveryFees'] as num? ?? 0,
      id: json['_id'] as String? ?? '',
    );

Map<String, dynamic> _$BrandDeliveryFeesModelToJson(
        BrandDeliveryFeesModel instance) =>
    <String, dynamic>{
      'gov': instance.gov,
      'deliveryFees': instance.deliveryFees,
      '_id': instance.id,
    };
