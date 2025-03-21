import 'package:dazzify/features/booking/data/models/booking_brand_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_review_request_model.g.dart';

@JsonSerializable()
class BookingReviewRequestModel {
  @JsonKey(defaultValue: "")
  final String bookingId;

  @JsonKey(defaultValue: 0.0)
  final double totalPrice;

  final BookingBrandModel brand;

  const BookingReviewRequestModel({
    required this.bookingId,
    required this.totalPrice,
    required this.brand,
  });

  const BookingReviewRequestModel.empty([
    this.bookingId = "",
    this.brand = const BookingBrandModel.empty(),
    this.totalPrice = 0,
  ]);

  factory BookingReviewRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BookingReviewRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingReviewRequestModelToJson(this);
}
