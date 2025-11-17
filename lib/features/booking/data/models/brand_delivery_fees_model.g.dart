// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_delivery_fees_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandDeliveryFeesModel _$BrandDeliveryFeesModelFromJson(
        Map<String, dynamic> json) =>
    BrandDeliveryFeesModel(
      gov: (json['gov'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      transportationFeesType:
          json['transportationFeesType'] as String? ?? 'fixed',
      transportationFees: json['transportationFees'] as num? ?? 0,
      minTransportationFees: json['minTransportationFees'] as num?,
      maxTransportationFees: json['maxTransportationFees'] as num?,
      id: json['_id'] as String? ?? '',
    );

Map<String, dynamic> _$BrandDeliveryFeesModelToJson(
        BrandDeliveryFeesModel instance) =>
    <String, dynamic>{
      'gov': instance.gov,
      'name': instance.name,
      'transportationFeesType': instance.transportationFeesType,
      'transportationFees': instance.transportationFees,
      'minTransportationFees': instance.minTransportationFees,
      'maxTransportationFees': instance.maxTransportationFees,
      '_id': instance.id,
    };
