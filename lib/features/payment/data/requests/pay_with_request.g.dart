// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_with_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayWithRequest _$PayWithRequestFromJson(Map<String, dynamic> json) =>
    PayWithRequest(
      transactionId: json['transactionId'] as String,
      paymentMethod: json['paymentMethod'] as String,
    );

Map<String, dynamic> _$PayWithRequestToJson(PayWithRequest instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'paymentMethod': instance.paymentMethod,
    };
