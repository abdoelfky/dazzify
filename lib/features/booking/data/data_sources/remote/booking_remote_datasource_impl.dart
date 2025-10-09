import 'package:dartz/dartz.dart';
import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/features/booking/data/data_sources/remote/booking_remote_datasource.dart';
import 'package:dazzify/features/booking/data/models/booking_review_request_model.dart';
import 'package:dazzify/features/booking/data/models/bookings_list_model.dart';
import 'package:dazzify/features/booking/data/models/brand_delivery_fees_model.dart';
import 'package:dazzify/features/booking/data/models/coupon_model.dart';
import 'package:dazzify/features/booking/data/models/last_active_booking_model.dart';
import 'package:dazzify/features/booking/data/models/single_booking_model.dart';
import 'package:dazzify/features/booking/data/models/vendor_session_model.dart';
import 'package:dazzify/features/booking/data/requests/create_booking_request.dart';
import 'package:dazzify/features/booking/data/requests/create_booking_review_request.dart';
import 'package:dazzify/features/booking/data/requests/get_bookings_list_request.dart';
import 'package:dazzify/features/booking/data/requests/get_brand_slots_request.dart';
import 'package:dazzify/features/booking/data/requests/get_location_name_request.dart';
import 'package:dazzify/features/booking/data/requests/user_arrived_request.dart';
import 'package:dazzify/features/booking/data/requests/validate_coupon_request.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingRemoteDatasource)
class BookingRemoteDatasourceImpl extends BookingRemoteDatasource {
  final ApiConsumer _apiConsumer;

  const BookingRemoteDatasourceImpl(this._apiConsumer);

  @override
  Future<List<VendorSessionModel>> getBrandServiceAvailableSlots({
    required GetBrandSlotsRequest request,
  }) async {
    return await _apiConsumer.post<VendorSessionModel>(
      ApiConstants.getBrandServiceAvailableSlots,
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: VendorSessionModel.fromJson,
      body: request.toJson(),
    );
  }

  @override
  Future<List<VendorSessionModel>> getBrandMultipleServicesAvailableSlots({
    required GetBrandSlotsRequest request,
  }) async {
    return await _apiConsumer.post<VendorSessionModel>(
      ApiConstants.getBrandMultipleServicesAvailableSlots,
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: VendorSessionModel.fromJson,
      body: request.toJson(),
    );
  }

  @override
  Future<List<String>> getBrandTerms({required String brandId}) async {
    return await _apiConsumer.get<String>(
      ApiConstants.brandTerms(brandId: brandId),
      responseReturnType: ResponseReturnType.primitiveList,
    );
  }

  @override
  Future<void> createBooking({
    required CreateBookingRequest request,
  }) async {
    await _apiConsumer.post<void>(
      ApiConstants.createBooking,
      responseReturnType: ResponseReturnType.unit,
      body: request.toJson(),
    );
  }

  @override
  Future<List<BrandDeliveryFeesModel>> getBrandDeliveryFees({
    required String brandId,
  }) async {
    return await _apiConsumer.get<BrandDeliveryFeesModel>(
      ApiConstants.getBrandDeliveryFees(brandId),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: BrandDeliveryFeesModel.fromJson,
    );
  }

  @override
  Future<CouponModel> validateCoupon({
    required String brandId,
    required ValidateCouponRequest request,
  }) async {
    return await _apiConsumer.post<CouponModel>(
      ApiConstants.validateCoupn(brandId),
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: CouponModel.fromJson,
      body: request.toJson(),
    );
  }

  @override
  Future<String> getLocationName({
    required GetLocationNameRequest request,
  }) async {
    return await _apiConsumer.get<String>(
      ApiConstants.getLocationName,
      responseReturnType: ResponseReturnType.primitiveWithKey,
      primitiveKey: "name",
      queryParameters: request.toJson(),
    );
  }

  @override
  Future<List<BookingsListModel>> getBookingsList({
    required GetBookingsListRequest request,
  }) async {
    return await _apiConsumer.get<BookingsListModel>(
      ApiConstants.bookingsList,
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: BookingsListModel.fromJson,
      queryParameters: request.toJson(),
    );
  }

  @override
  Future<SingleBookingModel> getSingleBooking({
    required String bookingId,
  }) async {
    return await _apiConsumer.get<SingleBookingModel>(
      ApiConstants.singleBooking(bookingId),
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: SingleBookingModel.fromJson,
    );
  }

  @override
  Future<Unit> cancelBooking({
    required String bookingId,
  }) async {
    await _apiConsumer.delete<void>(
      ApiConstants.cancelBooking(bookingId),
      responseReturnType: ResponseReturnType.unit,
    );
    return unit;
  }

  @override
  Future<Unit> userArrived({
    required String bookingId,
    required UserArrivedRequest request,
  }) async {
    await _apiConsumer.post<void>(
      ApiConstants.userArrived(bookingId),
      responseReturnType: ResponseReturnType.unit,
      body: {
        "location": request.toJson(),
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "hash": AppConstants.generateLocationHash(request.latitude,
            request.longitude, DateTime.now().millisecondsSinceEpoch)
      },
    );
    return unit;
  }

  @override
  Future<Unit> createBookingReview({
    required CreateBookingReviewRequest request,
  }) async {
    await _apiConsumer.post<void>(
      ApiConstants.createReview,
      responseReturnType: ResponseReturnType.unit,
      body: request.toJson(),
    );
    return unit;
  }

  @override
  Future<List<LastActiveBookingModel>> getLastActiveBookings() async {
    try {
      return await _apiConsumer.get<LastActiveBookingModel>(
        ApiConstants.lastActiveBooking,
        responseReturnType: ResponseReturnType.fromJsonList,
        fromJsonMethod: LastActiveBookingModel.fromJson,
      );
    } on SessionCancelledException {
      // Session expired, return empty list instead of crashing
      return [];
    }
  }

  @override
  Future<BookingReviewRequestModel> getMissedReview() async {
    try {
      return await _apiConsumer.get<BookingReviewRequestModel>(
        ApiConstants.getMissedReviews,
        responseReturnType: ResponseReturnType.fromJson,
        fromJsonMethod: BookingReviewRequestModel.fromJson,
      );
    } on SessionCancelledException {
      // Session expired, return default model
      return BookingReviewRequestModel();
    }
  }

  @override
  Future<Unit> setNotInterestedToReview({required String bookingId}) async {
    await _apiConsumer.post<Unit>(
      ApiConstants.notInterestedToReview,
      responseReturnType: ResponseReturnType.unit,
      body: {"bookingId": bookingId},
    );

    return unit;
  }
}
