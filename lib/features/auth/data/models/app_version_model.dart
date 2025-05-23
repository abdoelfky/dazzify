import 'package:json_annotation/json_annotation.dart';

part 'app_version_model.g.dart';

@JsonSerializable()
class AppVersion {
  final bool forceUpdate;
  final String android;
  final String androidDownloadLink;
  final String ios;
  final String iosDownloadLink;

  const AppVersion({
    required this.forceUpdate,
    required this.android,
    required this.androidDownloadLink,
    required this.ios,
    required this.iosDownloadLink,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) =>
      _$AppVersionFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionToJson(this);
}
