// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      image: json['image'] as String? ?? '',
      action: json['action'] as String? ?? '',
      url: json['url'] as String?,
      coupon: json['coupon'] as String?,
      mainCategory: json['mainCategory'] == null
          ? null
          : MainCategoryData.fromJson(
              json['mainCategory'] as Map<String, dynamic>),
      brand: json['brand'] == null
          ? null
          : BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      service: json['service'] == null
          ? null
          : ServiceData.fromJson(json['service'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'action': instance.action,
      'url': instance.url,
      'coupon': instance.coupon,
      'mainCategory': instance.mainCategory,
      'brand': instance.brand,
      'service': instance.service,
    };

MainCategoryData _$MainCategoryDataFromJson(Map<String, dynamic> json) =>
    MainCategoryData(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$MainCategoryDataToJson(MainCategoryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ServiceData _$ServiceDataFromJson(Map<String, dynamic> json) => ServiceData(
      brandId: json['brandId'] as String,
      serviceId: json['serviceId'] as String,
    );

Map<String, dynamic> _$ServiceDataToJson(ServiceData instance) =>
    <String, dynamic>{
      'brandId': instance.brandId,
      'serviceId': instance.serviceId,
    };
