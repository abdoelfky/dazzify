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

  // Location coordinates (optional)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double? longitude;
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double? latitude;

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
    this.longitude,
    this.latitude,
  });

  const BrandDeliveryFeesModel.empty({
    this.gov = 0,
    this.name = "",
    this.transportationFeesType = "fixed",
    this.transportationFees = 0,
    this.minTransportationFees,
    this.maxTransportationFees,
    this.id = "",
    this.longitude,
    this.latitude,
  });

  bool get isFixedType => transportationFeesType == 'fixed';
  bool get isRangeType => transportationFeesType == 'range';

  factory BrandDeliveryFeesModel.fromJson(Map<String, dynamic> json) {
    final model = _$BrandDeliveryFeesModelFromJson(json);
    
    // Extract location coordinates from nested location object
    final location = json['location'] as Map<String, dynamic>?;
    if (location != null) {
      return BrandDeliveryFeesModel(
        gov: model.gov,
        name: model.name,
        transportationFeesType: model.transportationFeesType,
        transportationFees: model.transportationFees,
        minTransportationFees: model.minTransportationFees,
        maxTransportationFees: model.maxTransportationFees,
        id: model.id,
        longitude: (location['longitude'] as num?)?.toDouble(),
        latitude: (location['latitude'] as num?)?.toDouble(),
      );
    }
    
    return model;
  }

  Map<String, dynamic> toJson() => _$BrandDeliveryFeesModelToJson(this);
}
