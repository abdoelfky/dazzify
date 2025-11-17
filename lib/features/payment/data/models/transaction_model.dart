import 'package:dazzify/features/payment/data/models/transaction_services_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String bookingId;
  @JsonKey(defaultValue: "")
  String status;
  @JsonKey(defaultValue: 0)
  final double amount;
  @JsonKey(defaultValue: 0)
  final int refundAmount;
  @JsonKey(defaultValue: "", name: "expAt")
  final String expiredAt;
  @JsonKey(defaultValue: "")
  final String createdAt;
  final String type;
  final List<TransactionServicesModel> services;

  TransactionModel({
    required this.id,
    required this.bookingId,
    required this.status,
    required this.amount,
    required this.refundAmount,
    required this.expiredAt,
    required this.createdAt,
    required this.type,
    required this.services,
  });

  TransactionModel.empty({
    this.id = "",
    this.bookingId = "",
    this.status = "",
    this.amount = 0,
    this.refundAmount = 0,
    this.expiredAt = "",
    this.createdAt = "",
    this.type = "",
    this.services = const [],
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
