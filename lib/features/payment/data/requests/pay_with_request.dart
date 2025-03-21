import 'package:json_annotation/json_annotation.dart';

part 'pay_with_request.g.dart';

@JsonSerializable()
class PayWithRequest {
  @JsonKey(name: "transactionId")
  final String transactionId;

  @JsonKey(name: "paymentMethod")
  final String paymentMethod;

  const PayWithRequest({
    required this.transactionId,
    required this.paymentMethod,
  });

  factory PayWithRequest.fromJson(Map<String, dynamic> json) =>
      _$PayWithRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PayWithRequestToJson(this);
}
