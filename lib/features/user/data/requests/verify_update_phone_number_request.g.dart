// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_update_phone_number_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyUpdatePhoneNumberRequest _$VerifyUpdatePhoneNumberRequestFromJson(
        Map<String, dynamic> json) =>
    VerifyUpdatePhoneNumberRequest(
      newPhoneNumber: json['newPhoneNumber'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$VerifyUpdatePhoneNumberRequestToJson(
        VerifyUpdatePhoneNumberRequest instance) =>
    <String, dynamic>{
      'newPhoneNumber': instance.newPhoneNumber,
      'otp': instance.otp,
    };
