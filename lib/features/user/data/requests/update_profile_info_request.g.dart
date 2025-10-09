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
    UpdateProfileInfoRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('gender', instance.gender);
  writeNotNull('birthday', instance.birthday);
  return val;
}
