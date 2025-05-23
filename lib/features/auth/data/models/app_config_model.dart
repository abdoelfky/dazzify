import 'package:json_annotation/json_annotation.dart';
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

  static DateTime? _fromJsonDateTime(String? date) =>
      date == null ? null : DateTime.tryParse(date);

  static String? _toJsonDateTime(DateTime? date) =>
      date?.toUtc().toIso8601String();
}
