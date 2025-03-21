import 'package:dartz/dartz.dart';
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

abstract class BookingRemoteDatasource {
  const BookingRemoteDatasource();

  Future<List<String>> getBrandTerms({
    required String brandId,
  });

  Future<List<VendorSessionModel>> getBrandServiceAvailableSlots({
    required GetBrandSlotsRequest request,
  });

  Future<List<VendorSessionModel>> getBrandMultipleServicesAvailableSlots({
    required GetBrandSlotsRequest request,
  });

  Future<void> createBooking({
    required CreateBookingRequest request,
  });

  Future<List<BrandDeliveryFeesModel>> getBrandDeliveryFees({
    required String brandId,
  });

  Future<CouponModel> validateCoupon({
    required String brandId,
    required ValidateCouponRequest request,
  });

  Future<String> getLocationName({
    required GetLocationNameRequest request,
  });

  Future<List<BookingsListModel>> getBookingsList({
    required GetBookingsListRequest request,
  });

  Future<SingleBookingModel> getSingleBooking({
    required String bookingId,
  });

  Future<Unit> cancelBooking({
    required String bookingId,
  });

  Future<Unit> userArrived({
    required String bookingId,
    required UserArrivedRequest request,
  });

  Future<Unit> createBookingReview({
    required CreateBookingReviewRequest request,
  });

  Future<BookingReviewRequestModel> getMissedReview();

  Future<Unit> setNotInterestedToReview({required String bookingId});

  Future<List<LastActiveBookingModel>> getLastActiveBookings();
}
