// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bookings_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBookingsListRequest _$GetBookingsListRequestFromJson(
        Map<String, dynamic> json) =>
    GetBookingsListRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetBookingsListRequestToJson(
        GetBookingsListRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
