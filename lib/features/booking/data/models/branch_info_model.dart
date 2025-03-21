import 'package:json_annotation/json_annotation.dart';

part 'branch_info_model.g.dart';

@JsonSerializable()
class BranchInfoModel {
  final String id;
  final String name;
  final double longitude;
  final double latitude;

  const BranchInfoModel({
    required this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
  });

  const BranchInfoModel.empty({
    this.name = '',
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.id = '',
  });

  factory BranchInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BranchInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchInfoModelToJson(this);
}
