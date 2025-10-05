// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpRequest _$SendOtpRequestFromJson(Map<String, dynamic> json) =>
    SendOtpRequest(
      phoneNumber: json['phoneNumber'] as String,
      languagePreference: json['languagePreference'] as String?,
    );

Map<String, dynamic> _$SendOtpRequestToJson(SendOtpRequest instance) {
  final val = <String, dynamic>{
    'phoneNumber': instance.phoneNumber,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('languagePreference', instance.languagePreference);
  return val;
}
