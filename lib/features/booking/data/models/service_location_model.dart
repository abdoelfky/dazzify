import 'package:json_annotation/json_annotation.dart';

part 'service_location_model.g.dart';

@JsonSerializable()
class ServiceLocationModel {
  final String name;
  final double longitude;
  final double latitude;
  final String? id;

  const ServiceLocationModel({
    required this.name,
    required this.longitude,
    required this.latitude,
    this.id,
  });

  const ServiceLocationModel.empty({
    this.name = '',
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.id,
  });

  factory ServiceLocationModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceLocationModelToJson(this);
}
