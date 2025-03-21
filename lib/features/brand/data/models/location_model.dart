import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  @JsonKey(defaultValue: 0)
  final double longitude;

  @JsonKey(defaultValue: 0)
  final double latitude;

  const LocationModel({
    required this.longitude,
    required this.latitude,
  });

  const LocationModel.empty([
    this.latitude = 0,
    this.longitude = 0,
  ]);

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
