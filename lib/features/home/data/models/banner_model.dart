import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  @JsonKey(defaultValue: "")
  final String image;
  @JsonKey(defaultValue: "")
  final String action;
  final String? url;
  final String? coupon;
  final MainCategoryData? mainCategory;
  final BrandModel? brand;
  final ServiceData? service;

  BannerModel({
    required this.image,
    required this.action,
    required this.url,
    required this.coupon,
    required this.mainCategory,
    required this.brand,
    required this.service,
  });

  const BannerModel.empty({
    this.image = '',
    this.action = '',
    this.url,
    this.coupon,
    this.mainCategory,
    this.brand,
    this.service,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}

@JsonSerializable()
class MainCategoryData {
  final String id;
  final String name;

  MainCategoryData({required this.id, required this.name});

  factory MainCategoryData.fromJson(Map<String, dynamic> json) =>
      _$MainCategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$MainCategoryDataToJson(this);
}

@JsonSerializable()
class ServiceData {
  final String brandId;
  final String serviceId;

  ServiceData({required this.brandId, required this.serviceId});

  const ServiceData.empty({this.brandId = '', this.serviceId = ''});

  factory ServiceData.fromJson(Map<String, dynamic> json) =>
      _$ServiceDataFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDataToJson(this);
}
