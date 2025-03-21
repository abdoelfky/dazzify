// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceDetailsModel _$ServiceDetailsModelFromJson(Map<String, dynamic> json) =>
    ServiceDetailsModel(
      id: json['id'] as String? ?? '',
      brand: BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: json['price'] as num? ?? 0,
      fees: (json['fees'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      bookingCount: (json['bookingCount'] as num?)?.toInt() ?? 0,
      includes: (json['includes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      serviceLocation: json['serviceLocation'] as String? ?? '',
      lateLimit: (json['lateLimit'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      inBranches: (json['inBranches'] as List<dynamic>?)
              ?.map((e) => InBranchesModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      ratingPercentage:
          (json['ratingPercentage'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              {},
      allowMultipleServicesBook:
          json['allowMultipleServicesBook'] as bool? ?? false,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ServiceDetailsModelToJson(
        ServiceDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand.toJson(),
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'price': instance.price,
      'fees': instance.fees,
      'duration': instance.duration,
      'bookingCount': instance.bookingCount,
      'includes': instance.includes,
      'serviceLocation': instance.serviceLocation,
      'allowMultipleServicesBook': instance.allowMultipleServicesBook,
      'lateLimit': instance.lateLimit,
      'type': instance.type,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'inBranches': instance.inBranches.map((e) => e.toJson()).toList(),
      'ratingPercentage': instance.ratingPercentage,
      'services': instance.services?.map((e) => e.toJson()).toList(),
    };
