// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersion _$AppVersionFromJson(Map<String, dynamic> json) => AppVersion(
      forceUpdate: json['forceUpdate'] as bool,
      android: json['android'] as String,
      androidDownloadLink: json['androidDownloadLink'] as String,
      ios: json['ios'] as String,
      iosDownloadLink: json['iosDownloadLink'] as String,
    );

Map<String, dynamic> _$AppVersionToJson(AppVersion instance) =>
    <String, dynamic>{
      'forceUpdate': instance.forceUpdate,
      'android': instance.android,
      'androidDownloadLink': instance.androidDownloadLink,
      'ios': instance.ios,
      'iosDownloadLink': instance.iosDownloadLink,
    };
