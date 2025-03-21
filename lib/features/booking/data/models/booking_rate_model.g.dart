// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRateModel _$BookingRateModelFromJson(Map<String, dynamic> json) =>
    BookingRateModel(
      comment: json['comment'] as String? ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$BookingRateModelToJson(BookingRateModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'rate': instance.rate,
    };
