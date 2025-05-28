// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      gender: json['gender'] as String? ?? '',
      email: json['email'] as String? ?? '',
      wallet: (json['wallet'] as num?)?.toInt() ?? 0,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      birthday: json['birthday'] as String? ?? '',
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'birthday': instance.birthday,
      'email': instance.email,
      'wallet': instance.wallet,
      'location': instance.location,
    };
