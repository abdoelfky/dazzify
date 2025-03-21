// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_booking_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBookingReviewRequest _$CreateBookingReviewRequestFromJson(
        Map<String, dynamic> json) =>
    CreateBookingReviewRequest(
      bookingId: json['bookingId'] as String,
      comment: json['comment'] as String,
      rate: (json['rate'] as num).toDouble(),
    );

Map<String, dynamic> _$CreateBookingReviewRequestToJson(
        CreateBookingReviewRequest instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'comment': instance.comment,
      'rate': instance.rate,
    };
