@JsonSerializable()
class AppVersion {
  final bool forceUpdate;
  final String android;
  final String ios;

  const AppVersion({
    required this.forceUpdate,
    required this.android,
    required this.ios,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) =>
      _$AppVersionFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionToJson(this);
}
