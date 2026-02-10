import 'package:json_annotation/json_annotation.dart';

part 'service_item_request.g.dart';

@JsonSerializable()
class ServiceItemRequest {
  @JsonKey(name: "serviceId")
  final String serviceId;
  @JsonKey(name: "quantity")
  final int quantity;

  const ServiceItemRequest({
    required this.serviceId,
    required this.quantity,
  });

  factory ServiceItemRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceItemRequestToJson(this);
}

