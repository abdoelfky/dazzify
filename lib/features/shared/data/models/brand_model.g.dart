// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => BrandModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
      allowMultipleServicesBook:
          json['allowMultipleServicesBook'] as bool? ?? false,
      refundConditions: (json['refundConditions'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      username: json['slug'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      totalBookingsCount: (json['totalBookingsCount'] as num?)?.toInt() ?? 0,
      points: (json['points'] as num?)?.toInt() ?? 0,
      minPrice: (json['minPrice'] as num?)?.toInt() ?? 0,
      maxPrice: (json['maxPrice'] as num?)?.toInt() ?? 0,
      bannerUrl: json['bannerUrl'] as String? ?? '',
    );

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'verified': instance.verified,
      'slug': instance.username,
      'phoneNumber': instance.phoneNumber,
      'description': instance.description,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'totalBookingsCount': instance.totalBookingsCount,
      'points': instance.points,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'bannerUrl': instance.bannerUrl,
      'allowMultipleServicesBook': instance.allowMultipleServicesBook,
      'refundConditions': instance.refundConditions,
    };
