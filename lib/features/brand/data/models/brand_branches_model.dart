import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand_branches_model.g.dart';

@JsonSerializable()
class BrandBranchesModel {
  @JsonKey(defaultValue: "")
  final String id;

  @JsonKey(defaultValue: "")
  final String name;

  final LocationModel location;

  @JsonKey(defaultValue: false)
  final bool isBusy;

  @JsonKey(defaultValue: 0)
  final int chairsCount;

  const BrandBranchesModel({
    required this.id,
    required this.name,
    required this.location,
    required this.isBusy,
    required this.chairsCount,
  });

  const BrandBranchesModel.empty([
    this.chairsCount = 0,
    this.id = '',
    this.isBusy = false,
    this.location = const LocationModel.empty(),
    this.name = '',
  ]);

  factory BrandBranchesModel.fromJson(Map<String, dynamic> json) =>
      _$BrandBranchesModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandBranchesModelToJson(this);
}
