// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryFeesRange _$DeliveryFeesRangeFromJson(Map<String, dynamic> json) =>
    DeliveryFeesRange(
      from: json['from'] as num? ?? 0,
      to: json['to'] as num? ?? 0,
    );

Map<String, dynamic> _$DeliveryFeesRangeToJson(DeliveryFeesRange instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
    };

SingleBookingModel _$SingleBookingModelFromJson(Map<String, dynamic> json) =>
    SingleBookingModel(
      id: json['id'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      isInBranch: json['isInBranch'] as bool? ?? false,
      isHasCoupon: json['isHasCoupon'] as bool? ?? false,
      price: (json['price'] as num?)?.toInt() ?? 0,
      couponDis: (json['couponDis'] as num?)?.toInt() ?? 0,
      fees: (json['fees'] as num?)?.toInt() ?? 0,
      deliveryFees: (json['deliveryFees'] as num?)?.toInt() ?? 0,
      deliveryFeesRange: json['deliveryFeesRange'] == null
          ? null
          : DeliveryFeesRange.fromJson(
              json['deliveryFeesRange'] as Map<String, dynamic>),
      totalPrice: (json['totalPrice'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      isFinished: json['isFinished'] as bool? ?? false,
      isRate: json['isRate'] as bool? ?? false,
      isArrived: json['isArrived'] as bool? ?? false,
      branch: BranchInfoModel.fromJson(json['branch'] as Map<String, dynamic>),
      brand: BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      services: (json['services'] as List<dynamic>)
          .map((e) => BookingServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookingLocation: ServiceLocationModel.fromJson(
          json['bookingLocation'] as Map<String, dynamic>),
      rating: BookingRateModel.fromJson(json['rating'] as Map<String, dynamic>),
      payments: (json['payments'] as List<dynamic>?)
              ?.map((e) =>
                  BookingPaymentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$SingleBookingModelToJson(SingleBookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isInBranch': instance.isInBranch,
      'isHasCoupon': instance.isHasCoupon,
      'price': instance.price,
      'couponDis': instance.couponDis,
      'fees': instance.fees,
      'deliveryFees': instance.deliveryFees,
      'deliveryFeesRange': instance.deliveryFeesRange,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'notes': instance.notes,
      'isFinished': instance.isFinished,
      'isRate': instance.isRate,
      'isArrived': instance.isArrived,
      'branch': instance.branch,
      'brand': instance.brand,
      'services': instance.services,
      'bookingLocation': instance.bookingLocation,
      'rating': instance.rating,
      'payments': instance.payments,
    };
