// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_user_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddUserInfoRequest _$AddUserInfoRequestFromJson(Map<String, dynamic> json) =>
    AddUserInfoRequest(
      fullName: json['fullName'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      birthDay: json['birthday'] as String,
      lang: json['languagePreference'] as String,
    );

Map<String, dynamic> _$AddUserInfoRequestToJson(AddUserInfoRequest instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'gender': instance.gender,
      'email': instance.email,
      'birthday': instance.birthDay,
      'languagePreference': instance.lang,
    };
