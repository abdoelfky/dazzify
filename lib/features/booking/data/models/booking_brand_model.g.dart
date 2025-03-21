// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingBrandModel _$BookingBrandModelFromJson(Map<String, dynamic> json) =>
    BookingBrandModel(
      name: json['name'] as String,
      logo: json['logo'] as String,
      verified: json['verified'] as bool,
    );

Map<String, dynamic> _$BookingBrandModelToJson(BookingBrandModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'logo': instance.logo,
      'verified': instance.verified,
    };
