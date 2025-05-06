// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestModel _$GuestModelFromJson(Map<String, dynamic> json) => GuestModel(
      guestMode: json['guestMode'] as bool? ?? false,
      guestToken: json['guestToken'] as String? ?? '',
      guestTokenExpireTime: DateTime.parse(json['guestTokenExpireTime']),

    );

Map<String, dynamic> _$GuestModelToJson(GuestModel instance) =>
    <String, dynamic>{
      'guestMode': instance.guestMode,
      'guestToken': instance.guestToken,
      'guestTokenExpireTime': instance.guestTokenExpireTime?.toIso8601String(),
    };
