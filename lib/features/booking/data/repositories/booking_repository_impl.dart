import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/booking/data/data_sources/remote/booking_remote_datasource.dart';
import 'package:dazzify/features/booking/data/models/booking_review_request_model.dart';
import 'package:dazzify/features/booking/data/models/bookings_list_model.dart';
import 'package:dazzify/features/booking/data/models/brand_delivery_fees_model.dart';
import 'package:dazzify/features/booking/data/models/coupon_model.dart';
import 'package:dazzify/features/booking/data/models/last_active_booking_model.dart';
import 'package:dazzify/features/booking/data/models/single_booking_model.dart';
import 'package:dazzify/features/booking/data/models/vendor_session_model.dart';
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart';
import 'package:dazzify/features/booking/data/requests/create_booking_request.dart';
import 'package:dazzify/features/booking/data/requests/create_booking_review_request.dart';
import 'package:dazzify/features/booking/data/requests/get_bookings_list_request.dart';
import 'package:dazzify/features/booking/data/requests/get_brand_slots_request.dart';
import 'package:dazzify/features/booking/data/requests/get_location_name_request.dart';
import 'package:dazzify/features/booking/data/requests/user_arrived_request.dart';
import 'package:dazzify/features/booking/data/requests/validate_coupon_request.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingRepository)
class BookingRepositoryImpl extends BookingRepository {
  final BookingRemoteDatasource _bookingRemoteDatasource;

  const BookingRepositoryImpl(this._bookingRemoteDatasource);

  @override
  Future<Either<Failure, List<String>>> getBrandTerms({
    required String brandId,
  }) async {
    try {
      final result = await _bookingRemoteDatasource.getBrandTerms(
        brandId: brandId,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, List<VendorSessionModel>>>
      getBrandServiceAvailableSlots({
    required GetBrandSlotsRequest request,
  }) async {
    try {
      final result =
          await _bookingRemoteDatasource.getBrandServiceAvailableSlots(
        request: request,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, List<VendorSessionModel>>>
      getBrandMultipleServicesAvailableSlots({
    required GetBrandSlotsRequest request,
  }) async {
    try {
      final result =
          await _bookingRemoteDatasource.getBrandMultipleServicesAvailableSlots(
        request: request,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> createBooking({
    required CreateBookingRequest request,
  }) async {
    try {
      await _bookingRemoteDatasource.createBooking(
        request: request,
      );
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, List<BrandDeliveryFeesModel>>> getBrandDeliveryFees({
    required String brandId,
  }) async {
    try {
      final result = await _bookingRemoteDatasource.getBrandDeliveryFees(
        brandId: brandId,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, CouponModel>> validateCoupon({
    required String brandId,
    required ValidateCouponRequest request,
  }) async {
    try {
      final result = await _bookingRemoteDatasource.validateCoupon(
        brandId: brandId,
        request: request,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, String>> getLocationName({
    required GetLocationNameRequest request,
  }) async {
    try {
      final result = await _bookingRemoteDatasource.getLocationName(
        request: request,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, List<BookingsListModel>>> getBookingsList({
    required GetBookingsListRequest request,
  }) async {
    try {
      final result = await _bookingRemoteDatasource.getBookingsList(
        request: request,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, SingleBookingModel>> getSingleBooking({
    required String bookingId,
  }) async {
    try {
      final result = await _bookingRemoteDatasource.getSingleBooking(
        bookingId: bookingId,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelBooking({
    required String bookingId,
  }) async {
    try {
      await _bookingRemoteDatasource.cancelBooking(
        bookingId: bookingId,
      );
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> userArrived({
    required String bookingId,
    required UserArrivedRequest request,
  }) async {
    try {
      await _bookingRemoteDatasource.userArrived(
        bookingId: bookingId,
        request: request,
      );
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> createBookingReview({
    required CreateBookingReviewRequest request,
  }) async {
    try {
      await _bookingRemoteDatasource.createBookingReview(
        request: request,
      );
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, List<LastActiveBookingModel>>>
      getLastActiveBookings() async {
    try {
      final result = await _bookingRemoteDatasource.getLastActiveBookings();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, BookingReviewRequestModel>> getMissedReview() async {
    try {
      final result = await _bookingRemoteDatasource.getMissedReview();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> setNotInterestedToReview(
      {required String bookingId}) async {
    try {
      final result = await _bookingRemoteDatasource.setNotInterestedToReview(
          bookingId: bookingId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ApiFailure(message: failure.message!));
    }
  }
}
