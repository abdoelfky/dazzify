import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
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

abstract class BookingRepository {
  const BookingRepository();

  Future<Either<Failure, List<String>>> getBrandTerms({
    required String brandId,
  });

  Future<Either<Failure, List<VendorSessionModel>>>
      getBrandServiceAvailableSlots({
    required GetBrandSlotsRequest request,
  });

  Future<Either<Failure, List<VendorSessionModel>>>
      getBrandMultipleServicesAvailableSlots({
    required GetBrandSlotsRequest request,
  });

  Future<Either<Failure, Unit>> createBooking({
    required CreateBookingRequest request,
  });

  Future<Either<Failure, List<BrandDeliveryFeesModel>>> getBrandDeliveryFees({
    required String brandId,
  });

  Future<Either<Failure, CouponModel>> validateCoupon({
    required String brandId,
    required ValidateCouponRequest request,
  });

  Future<Either<Failure, String>> getLocationName({
    required GetLocationNameRequest request,
  });

  Future<Either<Failure, List<BookingsListModel>>> getBookingsList({
    required GetBookingsListRequest request,
  });

  Future<Either<Failure, SingleBookingModel>> getSingleBooking({
    required String bookingId,
  });

  Future<Either<Failure, Unit>> cancelBooking({
    required String bookingId,
  });

  Future<Either<Failure, Unit>> userArrived({
    required String bookingId,
    required UserArrivedRequest request,
  });

  Future<Either<Failure, Unit>> createBookingReview({
    required CreateBookingReviewRequest request,
  });

  Future<Either<Failure, List<LastActiveBookingModel>>> getLastActiveBookings();

  Future<Either<Failure, BookingReviewRequestModel>> getMissedReview();

  Future<Either<Failure, Unit>> setNotInterestedToReview(
      {required String bookingId});
}
