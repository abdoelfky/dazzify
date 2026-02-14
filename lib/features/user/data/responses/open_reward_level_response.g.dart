// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_reward_level_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenRewardLevelResponse _$OpenRewardLevelResponseFromJson(
        Map<String, dynamic> json) =>
    OpenRewardLevelResponse(
      levelNumber: (json['levelNumber'] as num).toInt(),
      code: json['code'] as String,
    );

Map<String, dynamic> _$OpenRewardLevelResponseToJson(
        OpenRewardLevelResponse instance) =>
    <String, dynamic>{
      'levelNumber': instance.levelNumber,
      'code': instance.code,
    };
