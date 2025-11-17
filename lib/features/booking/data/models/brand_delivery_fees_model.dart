import 'package:json_annotation/json_annotation.dart';

part 'brand_delivery_fees_model.g.dart';

@JsonSerializable()
class BrandDeliveryFeesModel {
  @JsonKey(defaultValue: 0)
  final int gov;

  @JsonKey(defaultValue: "")
  final String name;

  @JsonKey(defaultValue: "fixed")
  final String transportationFeesType; // 'fixed' or 'range'

  // For fixed type
  @JsonKey(defaultValue: 0)
  final num? transportationFees;

  // For range type
  final num? minTransportationFees;
  final num? maxTransportationFees;

  @JsonKey(name: '_id', defaultValue: "")
  final String id;

  // Backward compatibility getter
  num get deliveryFees => transportationFees ?? minTransportationFees ?? 0;

  BrandDeliveryFeesModel({
    required this.gov,
    required this.name,
    required this.transportationFeesType,
    this.transportationFees,
    this.minTransportationFees,
    this.maxTransportationFees,
    required this.id,
  });

  const BrandDeliveryFeesModel.empty({
    this.gov = 0,
    this.name = "",
    this.transportationFeesType = "fixed",
    this.transportationFees = 0,
    this.minTransportationFees,
    this.maxTransportationFees,
    this.id = "",
  });

  bool get isFixedType => transportationFeesType == 'fixed';
  bool get isRangeType => transportationFeesType == 'range';

  factory BrandDeliveryFeesModel.fromJson(Map<String, dynamic> json) =>
      _$BrandDeliveryFeesModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandDeliveryFeesModelToJson(this);
}
