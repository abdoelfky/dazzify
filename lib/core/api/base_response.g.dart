// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
      status: json['status'] as String,
      error: json['error'] == null
          ? null
          : BackEndError.fromJson(json['error'] as Map<String, dynamic>),
      data: json['data'],
    );

BackEndError _$BackEndErrorFromJson(Map<String, dynamic> json) => BackEndError(
      code: (json['code'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
    );
