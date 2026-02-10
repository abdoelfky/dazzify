// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceItemRequest _$ServiceItemRequestFromJson(Map<String, dynamic> json) =>
    ServiceItemRequest(
      serviceId: json['serviceId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$ServiceItemRequestToJson(ServiceItemRequest instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'quantity': instance.quantity,
    };
