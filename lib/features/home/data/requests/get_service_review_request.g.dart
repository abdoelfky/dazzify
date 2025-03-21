// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_service_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetServiceReviewRequest _$GetServiceReviewRequestFromJson(
        Map<String, dynamic> json) =>
    GetServiceReviewRequest(
      serviceId: json['serviceId'] as String,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetServiceReviewRequestToJson(
        GetServiceReviewRequest instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'page': instance.page,
      'limit': instance.limit,
    };
