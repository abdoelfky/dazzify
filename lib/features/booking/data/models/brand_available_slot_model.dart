import 'package:json_annotation/json_annotation.dart';

part 'brand_available_slot_model.g.dart';

@JsonSerializable()
class BrandAvailableSlotModel {
  final String startTime;
  final String endTime;

  BrandAvailableSlotModel({
    required this.startTime,
    required this.endTime,
  });

  const BrandAvailableSlotModel.empty({
    this.startTime = '',
    this.endTime = '',
  });

  factory BrandAvailableSlotModel.fromJson(Map<String, dynamic> json) =>
      _$BrandAvailableSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandAvailableSlotModelToJson(this);
}
