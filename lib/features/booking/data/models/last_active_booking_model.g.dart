// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_active_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastActiveBookingModel _$LastActiveBookingModelFromJson(
        Map<String, dynamic> json) =>
    LastActiveBookingModel(
      id: json['id'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      services: (json['services'] as List<dynamic>)
          .map((e) => ActiveBookingService.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LastActiveBookingModelToJson(
        LastActiveBookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'services': instance.services,
    };

ActiveBookingService _$ActiveBookingServiceFromJson(
        Map<String, dynamic> json) =>
    ActiveBookingService(
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$ActiveBookingServiceToJson(
        ActiveBookingService instance) =>
    <String, dynamic>{
      'title': instance.title,
      'image': instance.image,
      'duration': instance.duration,
      'quantity': instance.quantity,
    };
