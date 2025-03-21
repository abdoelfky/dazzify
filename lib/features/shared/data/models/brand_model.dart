import 'package:json_annotation/json_annotation.dart';

part 'brand_model.g.dart';

@JsonSerializable()
class BrandModel {
  @JsonKey(defaultValue: "")
  final String id;

  @JsonKey(defaultValue: "")
  final String name;

  @JsonKey(defaultValue: "")
  final String logo;

  @JsonKey(defaultValue: false)
  final bool verified;

  @JsonKey(name: 'slug', defaultValue: "")
  final String? username;

  @JsonKey(defaultValue: "")
  final String? phoneNumber;

  @JsonKey(defaultValue: "")
  final String? description;

  @JsonKey(defaultValue: 0)
  final int? rating;

  @JsonKey(defaultValue: 0)
  final int? ratingCount;

  @JsonKey(defaultValue: 0)
  final int? totalBookingsCount;

  @JsonKey(defaultValue: 0)
  final int? points;

  @JsonKey(defaultValue: 0)
  final int? minPrice;

  @JsonKey(defaultValue: 0)
  final int? maxPrice;

  @JsonKey(defaultValue: '')
  final String? bannerUrl;

  @JsonKey(defaultValue: false)
  final bool allowMultipleServicesBook;
  @JsonKey(defaultValue: [])
  final List<String> refundConditions;

  const BrandModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.verified,
    required this.allowMultipleServicesBook,
    required this.refundConditions,
    this.username,
    this.phoneNumber,
    this.description,
    this.rating,
    this.ratingCount,
    this.totalBookingsCount,
    this.points,
    this.minPrice,
    this.maxPrice,
    this.bannerUrl,
  });

  const BrandModel.empty([
    this.id = '',
    this.name = '',
    this.logo = '',
    this.verified = false,
    this.username = '',
    this.phoneNumber = '',
    this.description = '',
    this.rating = 0,
    this.ratingCount = 0,
    this.totalBookingsCount = 0,
    this.points = 0,
    this.minPrice = 0,
    this.maxPrice = 0,
    this.bannerUrl = '',
    this.allowMultipleServicesBook = false,
    this.refundConditions = const [],
  ]);

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);
}
