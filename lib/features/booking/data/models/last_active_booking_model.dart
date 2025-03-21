import 'package:json_annotation/json_annotation.dart';

part 'last_active_booking_model.g.dart';

@JsonSerializable()
class LastActiveBookingModel {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String startTime;
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(defaultValue: '')
  final String createdAt;
  final List<ActiveBookingService> services;

  LastActiveBookingModel({
    required this.id,
    required this.startTime,
    required this.status,
    required this.createdAt,
    required this.services,
  });

  const LastActiveBookingModel.empty({
    this.id = '',
    this.startTime = '',
    this.status = '',
    this.createdAt = '',
    this.services = const [
      ActiveBookingService.empty(),
      ActiveBookingService.empty(),
      ActiveBookingService.empty()
    ],
  });

  factory LastActiveBookingModel.fromJson(Map<String, dynamic> json) =>
      _$LastActiveBookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$LastActiveBookingModelToJson(this);
}

@JsonSerializable()
class ActiveBookingService {
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: 0)
  final int duration;

  ActiveBookingService({
    required this.title,
    required this.image,
    required this.duration,
  });

  const ActiveBookingService.empty({
    this.title = '',
    this.image = '',
    this.duration = 0,
  });

  factory ActiveBookingService.fromJson(Map<String, dynamic> json) =>
      _$ActiveBookingServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveBookingServiceToJson(this);
}
