// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brand_slots_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBrandSlotsRequest _$GetBrandSlotsRequestFromJson(
        Map<String, dynamic> json) =>
    GetBrandSlotsRequest(
      branchId: json['branchId'] as String?,
      serviceId: json['serviceId'] as String?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$GetBrandSlotsRequestToJson(
        GetBrandSlotsRequest instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      if (instance.serviceId case final value?) 'serviceId': value,
      if (instance.services case final value?) 'services': value,
      'month': instance.month,
      'year': instance.year,
    };
