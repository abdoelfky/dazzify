// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingPaymentModel _$BookingPaymentModelFromJson(Map<String, dynamic> json) =>
    BookingPaymentModel(
      transactionId: json['transactionId'] as String,
      amount: (json['amount'] as num).toDouble(),
      expAt: json['expAt'] as String,
      type: json['type'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$BookingPaymentModelToJson(
        BookingPaymentModel instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'expAt': instance.expAt,
      'type': instance.type,
      'createdAt': instance.createdAt,
    };
