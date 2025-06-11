import 'package:dazzify/features/booking/data/models/booking_rate_model.dart';
import 'package:dazzify/features/booking/data/models/booking_service_model.dart';
import 'package:dazzify/features/booking/data/models/branch_info_model.dart';
import 'package:dazzify/features/booking/data/models/service_location_model.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'single_booking_model.g.dart';

@JsonSerializable()
class SingleBookingModel {
  @JsonKey(defaultValue: "")
  final String id;

  @JsonKey(defaultValue: "")
  final String startTime;

  @JsonKey(defaultValue: "")
  final String endTime;

  @JsonKey(defaultValue: false)
  final bool isInBranch;

  @JsonKey(defaultValue: false)
  final bool isHasCoupon;

  @JsonKey(defaultValue: 0)
  final int price;

  @JsonKey(defaultValue: 0)
  final int couponDis;

  @JsonKey(defaultValue: 0)
  final int fees;

  @JsonKey(defaultValue: 0)
  final int deliveryFees;

  @JsonKey(defaultValue: 0)
  final int totalPrice;

  @JsonKey(defaultValue: "")
  final String status;

  @JsonKey(defaultValue: "")
  final String notes;

  @JsonKey(defaultValue: false)
  final bool isFinished;

  @JsonKey(defaultValue: false)
  final bool isRate;

  @JsonKey(defaultValue: false, name: "isArrived")
  final bool isArrived;

  final BranchInfoModel branch;
  final BrandModel brand;
  final List<BookingServiceModel> services;
  final ServiceLocationModel bookingLocation;
  final BookingRateModel rating;

  const SingleBookingModel({
    required this.id,
    required this.notes,
    required this.startTime,
    required this.endTime,
    required this.isInBranch,
    required this.isHasCoupon,
    required this.price,
    required this.couponDis,
    required this.fees,
    required this.deliveryFees,
    required this.totalPrice,
    required this.status,
    required this.isFinished,
    required this.isRate,
    required this.isArrived,
    required this.branch,
    required this.brand,
    required this.services,
    required this.bookingLocation,
    required this.rating,
  });

  const SingleBookingModel.loading({
    this.id = '',
    this.notes = '',
    this.startTime = '',
    this.endTime = '',
    this.isInBranch = false,
    this.isHasCoupon = false,
    this.price = 0,
    this.couponDis = 0,
    this.fees = 0,
    this.deliveryFees = 0,
    this.totalPrice = 0,
    this.status = '',
    this.isFinished = false,
    this.isRate = false,
    this.isArrived = false,
    this.branch = const BranchInfoModel.empty(),
    this.brand = const BrandModel.empty(),
    this.services = const [],
    this.bookingLocation = const ServiceLocationModel.empty(),
    this.rating = const BookingRateModel.empty(),
  });

  factory SingleBookingModel.fromJson(Map<String, dynamic> json) =>
      _$SingleBookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SingleBookingModelToJson(this);

  const SingleBookingModel.empty([
    this.id = '',
    this.notes = '',
    this.startTime = '',
    this.endTime = '',
    this.isInBranch = false,
    this.isHasCoupon = false,
    this.price = 0,
    this.couponDis = 0,
    this.fees = 0,
    this.deliveryFees = 0,
    this.totalPrice = 0,
    this.status = '',
    this.isFinished = false,
    this.isRate = false,
    this.isArrived = false,
    this.branch = const BranchInfoModel.empty(),
    this.brand = const BrandModel.empty(),
    this.services = const [],
    this.bookingLocation = const ServiceLocationModel.empty(),
    this.rating = const BookingRateModel.empty(),
  ]);

  SingleBookingModel copyWith({
    String? id,
    String? notes,
    String? startTime,
    String? endTime,
    bool? isInBranch,
    bool? isHasCoupon,
    int? price,
    int? couponDis,
    int? fees,
    int? deliveryFees,
    int? totalPrice,
    String? status,
    bool? isFinished,
    bool? isRate,
    bool? isArrived,
    BranchInfoModel? branch,
    BrandModel? brand,
    List<BookingServiceModel>? services,
    ServiceLocationModel? bookingLocation,
    BookingRateModel? rating,
    List<String>? refundConditions,
  }) {
    return SingleBookingModel(
      id: id ?? this.id,
      notes: notes ?? this.notes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isInBranch: isInBranch ?? this.isInBranch,
      isHasCoupon: isHasCoupon ?? this.isHasCoupon,
      price: price ?? this.price,
      couponDis: couponDis ?? this.couponDis,
      fees: fees ?? this.fees,
      deliveryFees: deliveryFees ?? this.deliveryFees,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      isFinished: isFinished ?? this.isFinished,
      isRate: isRate ?? this.isRate,
      isArrived: isArrived ?? this.isArrived,
      branch: branch ?? this.branch,
      brand: brand ?? this.brand,
      services: services ?? this.services,
      bookingLocation: bookingLocation ?? this.bookingLocation,
      rating: rating ?? this.rating,
    );
  }
}
