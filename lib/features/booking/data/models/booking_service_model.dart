import 'package:json_annotation/json_annotation.dart';

part 'booking_service_model.g.dart';

@JsonSerializable()
class BookingServiceModel {
  @JsonKey(defaultValue: "")
  final String id;

  @JsonKey(defaultValue: "")
  final String title;

  @JsonKey(defaultValue: "")
  final String description;

  @JsonKey(defaultValue: "")
  final String image;

  @JsonKey(defaultValue: 0)
  final int duration;

  const BookingServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.duration,
  });

  const BookingServiceModel.empty({
    this.id = "",
    this.title = "",
    this.description = "",
    this.image = "",
    this.duration = 0,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) =>
      _$BookingServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingServiceModelToJson(this);
}
