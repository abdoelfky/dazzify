import 'package:json_annotation/json_annotation.dart';
part 'booking_payment_model.g.dart';

@JsonSerializable()
class BookingPaymentModel {
  final String transactionId;
  final double amount;
  final String expAt;
  final String type;
  final String createdAt;

  const BookingPaymentModel({
    required this.transactionId,
    required this.amount,
    required this.expAt,
    required this.type,
    required this.createdAt,
  });

  factory BookingPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$BookingPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingPaymentModelToJson(this);

  static const empty = BookingPaymentModel(
    transactionId: '',
    amount: 0.0,
    expAt: '',
    type: '',
    createdAt: '',
  );
}
