import 'package:json_annotation/json_annotation.dart';

part 'payment_method_model.g.dart';

@JsonSerializable()
class PaymentMethodModel {
  final String id;
  final String name;
  final String image;
  final String type;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });

  const PaymentMethodModel.empty({
    this.id = '',
    this.name = '',
    this.image = '',
    this.type = '',
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);
}
