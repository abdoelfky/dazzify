import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String title;
  @JsonKey(defaultValue: "")
  final String image;
  @JsonKey(defaultValue: 0)
  final int price;

  ServiceModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });

  const ServiceModel.empty({
    this.id = '',
    this.title = '',
    this.image = '',
    this.price = 0,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
