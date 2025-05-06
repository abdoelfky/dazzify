import 'package:json_annotation/json_annotation.dart';

part 'create_booking_request.g.dart';

@JsonSerializable()
class CreateBookingRequest {
  @JsonKey(name: "brandId")
  final String brandId;
  @JsonKey(name: "branchId")
  final String branchId;
  @JsonKey(name: "services")
  final List<String> services;
  @JsonKey(name: "startTime")
  final String startTime;
  @JsonKey(name: "isHasCoupon")
  final bool isHasCoupon;
  @JsonKey(name: "code", includeIfNull: false)
  final String? code;
  @JsonKey(name: "bookingLocation", includeIfNull: false)
  final Map<String, double>? bookingLocation;
  @JsonKey(name: "gov", includeIfNull: false)
  final int? gov;
  @JsonKey(name: "isInBranch", includeIfNull: false)
  final bool? isInBranch;

  const CreateBookingRequest({
    required this.brandId,
    required this.branchId,
    required this.services,
    required this.startTime,
    required this.isHasCoupon,
    this.code,
    this.bookingLocation,
    this.gov,
    this.isInBranch,
  });

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBookingRequestToJson(this);
}
