import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'in_branches_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InBranchesModel {
  @JsonKey(defaultValue: "")
  final String id;

  @JsonKey(defaultValue: "")
  final String name;

  final LocationModel location;

  InBranchesModel({
    required this.id,
    required this.name,
    required this.location,
  });

  factory InBranchesModel.fromJson(Map<String, dynamic> json) =>
      _$InBranchesModelFromJson(json);

  Map<String, dynamic> toJson() => _$InBranchesModelToJson(this);
}
