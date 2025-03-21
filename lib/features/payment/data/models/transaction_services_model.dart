import 'package:json_annotation/json_annotation.dart';

part 'transaction_services_model.g.dart';

@JsonSerializable()
class TransactionServicesModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String title;
  @JsonKey(defaultValue: "")
  final String description;
  @JsonKey(defaultValue: "")
  final String image;

  const TransactionServicesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  const TransactionServicesModel.empty({
    this.id = "",
    this.title = "",
    this.description = "",
    this.image = "",
  });

  factory TransactionServicesModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionServicesModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionServicesModelToJson(this);
}
