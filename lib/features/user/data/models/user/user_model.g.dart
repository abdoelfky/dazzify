// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      picture: json['picture'] as String?,
      username: json['username'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      deletedAt: json['deletedAt'] as String? ?? '',
      profile:
          UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      points: (json['points'] as num?)?.toInt() ?? 0,
      languagePreference: json['languagePreference'] as String? ?? 'en',
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'picture': instance.picture,
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'deletedAt': instance.deletedAt,
      'languagePreference': instance.languagePreference,
      'profile': instance.profile,
      'points': instance.points,
    };
