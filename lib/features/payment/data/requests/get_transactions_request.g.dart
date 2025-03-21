// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_transactions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTransactionsRequest _$GetTransactionsRequestFromJson(
        Map<String, dynamic> json) =>
    GetTransactionsRequest(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$GetTransactionsRequestToJson(
        GetTransactionsRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      if (instance.status case final value?) 'status': value,
    };
