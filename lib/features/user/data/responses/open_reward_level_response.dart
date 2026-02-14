import 'package:json_annotation/json_annotation.dart';

part 'open_reward_level_response.g.dart';

@JsonSerializable()
class OpenRewardLevelResponse {
  @JsonKey(name: "levelNumber")
  final int levelNumber;

  @JsonKey(name: "code")
  final String code;

  const OpenRewardLevelResponse({
    required this.levelNumber,
    required this.code,
  });

  factory OpenRewardLevelResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenRewardLevelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OpenRewardLevelResponseToJson(this);
}
