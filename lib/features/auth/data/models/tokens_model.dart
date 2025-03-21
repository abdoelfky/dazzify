import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tokens_model.g.dart';

@JsonSerializable(createToJson: false)
@HiveType(typeId: 1)
class TokensModel extends HiveObject {
  @HiveField(1)
  @JsonKey(defaultValue: "")
  final String accessToken;
  @HiveField(2)
  @JsonKey(defaultValue: "")
  final String? refreshToken;
  @HiveField(3)
  final DateTime accessTokenExpireTime;
  @HiveField(4)
  final DateTime? refreshTokenExpireTime;

  TokensModel({
    required this.accessToken,
    this.refreshToken,
    required this.accessTokenExpireTime,
    this.refreshTokenExpireTime,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);

  TokensModel copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? accessTokenExpireTime,
    DateTime? refreshTokenExpireTime,
  }) {
    return TokensModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accessTokenExpireTime:
          accessTokenExpireTime ?? this.accessTokenExpireTime,
      refreshTokenExpireTime:
          refreshTokenExpireTime ?? this.refreshTokenExpireTime,
    );
  }
}
