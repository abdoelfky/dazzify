// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brand_reviews_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBrandReviewsRequest _$GetBrandReviewsRequestFromJson(
        Map<String, dynamic> json) =>
    GetBrandReviewsRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetBrandReviewsRequestToJson(
        GetBrandReviewsRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
