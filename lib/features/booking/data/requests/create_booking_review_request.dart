import 'package:json_annotation/json_annotation.dart';

part 'create_booking_review_request.g.dart';

@JsonSerializable()
class CreateBookingReviewRequest {
  @JsonKey(name: "bookingId")
  final String bookingId;
  @JsonKey(name: "comment")
  final String comment;
  @JsonKey(name: "rate")
  final double rate;

  const CreateBookingReviewRequest({
    required this.bookingId,
    required this.comment,
    required this.rate,
  });

  factory CreateBookingReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBookingReviewRequestToJson(this);
}
