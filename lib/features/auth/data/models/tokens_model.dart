import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

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
  @JsonKey(fromJson: _fromJsonDateTime)
  final DateTime accessTokenExpireTime;
  @HiveField(4)
  @JsonKey(fromJson: _fromJsonDateTimeNullable)
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

  static DateTime _fromJsonDateTime(String date) {
    try {
      // Parse the datetime string
      final parsedDate = DateTime.parse(date);
      
      // Get Africa/Cairo timezone location
      final cairoLocation = tz.getLocation('Africa/Cairo');
      
      // Convert to Africa/Cairo timezone
      final cairoDateTime = tz.TZDateTime.from(parsedDate, cairoLocation);
      
      // Return as regular DateTime
      return cairoDateTime;
    } catch (e) {
      rethrow;
    }
  }

  static DateTime? _fromJsonDateTimeNullable(String? date) {
    if (date == null) return null;
    
    try {
      // Parse the datetime string
      final parsedDate = DateTime.parse(date);
      
      // Get Africa/Cairo timezone location
      final cairoLocation = tz.getLocation('Africa/Cairo');
      
      // Convert to Africa/Cairo timezone
      final cairoDateTime = tz.TZDateTime.from(parsedDate, cairoLocation);
      
      // Return as regular DateTime
      return cairoDateTime;
    } catch (e) {
      return null;
    }
  }
}
