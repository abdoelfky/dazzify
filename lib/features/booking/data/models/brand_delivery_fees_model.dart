import 'package:json_annotation/json_annotation.dart';

part 'brand_delivery_fees_model.g.dart';

@JsonSerializable()
class BrandDeliveryFeesModel {
  @JsonKey(defaultValue: 0)
  final int gov;

  @JsonKey(defaultValue: 0)
  final num deliveryFees;

  @JsonKey(name: '_id', defaultValue: "")
  final String id;

  BrandDeliveryFeesModel({
    required this.gov,
    required this.deliveryFees,
    required this.id,
  });

  const BrandDeliveryFeesModel.empty({
    this.gov = 0,
    this.deliveryFees = 0,
    this.id = "",
  });

  factory BrandDeliveryFeesModel.fromJson(Map<String, dynamic> json) =>
      _$BrandDeliveryFeesModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandDeliveryFeesModelToJson(this);
}
