import 'package:json_annotation/json_annotation.dart';

part 'booking_brand_model.g.dart';

@JsonSerializable()
class BookingBrandModel {
  final String name;
  final String logo;
  final bool verified;

  const BookingBrandModel({
    required this.name,
    required this.logo,
    required this.verified,
  });

  const BookingBrandModel.empty([
    this.name = "empty",
    this.logo = "",
    this.verified = false,
  ]);

  factory BookingBrandModel.fromJson(Map<String, dynamic> json) =>
      _$BookingBrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingBrandModelToJson(this);
}
