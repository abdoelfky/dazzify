// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileInfoRequest _$UpdateProfileInfoRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateProfileInfoRequest(
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] as String?,
    );

Map<String, dynamic> _$UpdateProfileInfoRequestToJson(
        UpdateProfileInfoRequest instance) =>
    <String, dynamic>{
      if (instance.email case final value?) 'email': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.birthday case final value?) 'birthday': value,
    };
