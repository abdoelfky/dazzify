// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      refundAmount: (json['refundAmount'] as num?)?.toInt() ?? 0,
      expiredAt: json['expAt'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      type: json['type'] as String,
      services: (json['services'] as List<dynamic>)
          .map((e) =>
              TransactionServicesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'status': instance.status,
      'amount': instance.amount,
      'refundAmount': instance.refundAmount,
      'expAt': instance.expiredAt,
      'createdAt': instance.createdAt,
      'type': instance.type,
      'services': instance.services,
    };
