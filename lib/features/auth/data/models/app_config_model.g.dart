// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigModel _$AppConfigModelFromJson(Map<String, dynamic> json) =>
    AppConfigModel(
      guestMode: json['guestMode'] as bool,
      guestToken: json['guestToken'] as String?,
      guestTokenExpireTime: AppConfigModel._fromJsonDateTime(
          json['guestTokenExpireTime'] as String?),
      appFees: AppFees.fromJson(json['appFees'] as Map<String, dynamic>),
      appVersion:
          AppVersion.fromJson(json['appVersion'] as Map<String, dynamic>),
      appInMaintenance: json['appInMaintenance'] as bool,
    );

Map<String, dynamic> _$AppConfigModelToJson(AppConfigModel instance) =>
    <String, dynamic>{
      'guestMode': instance.guestMode,
      'guestToken': instance.guestToken,
      'guestTokenExpireTime':
          AppConfigModel._toJsonDateTime(instance.guestTokenExpireTime),
      'appFees': instance.appFees,
      'appVersion': instance.appVersion,
      'appInMaintenance': instance.appInMaintenance,
    };
