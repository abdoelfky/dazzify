// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingsListModel _$BookingsListModelFromJson(Map<String, dynamic> json) =>
    BookingsListModel(
      id: json['id'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
      isFinished: json['isFinished'] as bool? ?? false,
      services: (json['services'] as List<dynamic>)
          .map((e) => BookingService.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookingsListModelToJson(BookingsListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime,
      'status': instance.status,
      'isFinished': instance.isFinished,
      'services': instance.services,
    };

BookingService _$BookingServiceFromJson(Map<String, dynamic> json) =>
    BookingService(
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BookingServiceToJson(BookingService instance) =>
    <String, dynamic>{
      'title': instance.title,
      'image': instance.image,
      'price': instance.price,
    };
