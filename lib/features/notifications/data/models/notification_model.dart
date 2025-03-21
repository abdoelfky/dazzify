import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  @JsonKey(defaultValue: "")
  final String type;
  @JsonKey(defaultValue: "")
  final String title;
  @JsonKey(defaultValue: "")
  final String body;
  @JsonKey(defaultValue: "")
  final String date;

  NotificationModel({
    required this.type,
    required this.title,
    required this.body,
    required this.date,
  });

  const NotificationModel.empty({
    this.type = "",
    this.title = "",
    this.body = "",
    this.date = "",
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
