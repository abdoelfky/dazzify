// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_review_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingReviewRequestModel _$BookingReviewRequestModelFromJson(
        Map<String, dynamic> json) =>
    BookingReviewRequestModel(
      bookingId: json['bookingId'] as String? ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      brand: BookingBrandModel.fromJson(json['brand'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingReviewRequestModelToJson(
        BookingReviewRequestModel instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'totalPrice': instance.totalPrice,
      'brand': instance.brand,
    };
