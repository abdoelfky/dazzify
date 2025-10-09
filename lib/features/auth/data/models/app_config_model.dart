import 'package:json_annotation/json_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'app_fees_model.dart';
import 'app_version_model.dart';
part 'app_config_model.g.dart';

@JsonSerializable()
class AppConfigModel {
  final bool guestMode;
  final String? guestToken;

  @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  final DateTime? guestTokenExpireTime;

  final AppFees appFees;
  final AppVersion appVersion;
  final bool appInMaintenance;

  const AppConfigModel({
    required this.guestMode,
    this.guestToken,
    this.guestTokenExpireTime,
    required this.appFees,
    required this.appVersion,
    required this.appInMaintenance,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigModelToJson(this);

  static DateTime? _fromJsonDateTime(String? date) {
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

  static String? _toJsonDateTime(DateTime? date) =>
      date?.toUtc().toIso8601String();
}
