// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingServiceModel _$BookingServiceModelFromJson(Map<String, dynamic> json) =>
    BookingServiceModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BookingServiceModelToJson(
        BookingServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'duration': instance.duration,
    };
