// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBookingRequest _$CreateBookingRequestFromJson(
        Map<String, dynamic> json) =>
    CreateBookingRequest(
      brandId: json['brandId'] as String,
      branchId: json['branchId'] as String,
      serviceId: json['serviceId'] as String,
      startTime: json['startTime'] as String,
      isHasCoupon: json['isHasCoupon'] as bool,
      couponId: json['couponId'] as String?,
      bookingLocation: (json['bookingLocation'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      gov: (json['gov'] as num?)?.toInt(),
      isInBranch: json['isInBranch'] as bool?,
    );

Map<String, dynamic> _$CreateBookingRequestToJson(
        CreateBookingRequest instance) =>
    <String, dynamic>{
      'brandId': instance.brandId,
      'branchId': instance.branchId,
      'serviceId': instance.serviceId,
      'startTime': instance.startTime,
      'isHasCoupon': instance.isHasCoupon,
      if (instance.couponId case final value?) 'couponId': value,
      if (instance.bookingLocation case final value?) 'bookingLocation': value,
      if (instance.gov case final value?) 'gov': value,
      if (instance.isInBranch case final value?) 'isInBranch': value,
    };
