// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateOtpRequest _$ValidateOtpRequestFromJson(Map<String, dynamic> json) =>
    ValidateOtpRequest(
      phoneNumber: json['phoneNumber'] as String,
      otpCode: json['otp'] as String,
      lang: json['languagePreference'] as String?,
    );

Map<String, dynamic> _$ValidateOtpRequestToJson(ValidateOtpRequest instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'otp': instance.otpCode,
      if (instance.lang case final value?) 'languagePreference': value,
    };
