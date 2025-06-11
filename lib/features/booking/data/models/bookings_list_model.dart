import 'package:json_annotation/json_annotation.dart';

part 'bookings_list_model.g.dart';

@JsonSerializable()
class BookingsListModel {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String startTime;
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(defaultValue: false)
  final bool isFinished;
  final List<BookingService> services;

  BookingsListModel({
    required this.id,
    required this.startTime,
    required this.status,
    required this.isFinished,
    required this.services,
  });

  factory BookingsListModel.fromJson(Map<String, dynamic> json) =>
      _$BookingsListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingsListModelToJson(this);

  const BookingsListModel.empty({
    this.id = '',
    this.startTime = '',
    this.status = '',
    this.isFinished = false,
    this.services = const [
      BookingService.empty(),
      BookingService.empty(),
      BookingService.empty()
    ],
  });
}

@JsonSerializable()
class BookingService {
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: 0)
  final int price;
  @JsonKey(defaultValue: 1)
  final int quantity;

  BookingService({
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  const BookingService.empty({
    this.title = '',
    this.image = '',
    this.price = 0,
    this.quantity = 1,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) =>
      _$BookingServiceFromJson(json);

  Map<String, dynamic> toJson() => _$BookingServiceToJson(this);
}
