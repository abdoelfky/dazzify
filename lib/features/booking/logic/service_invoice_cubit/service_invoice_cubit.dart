import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/services/tiktok_sdk_service.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/booking/data/models/brand_delivery_fees_model.dart';
import 'package:dazzify/features/booking/data/models/coupon_model.dart';
import 'package:dazzify/features/booking/data/models/delivery_info_model.dart';
import 'package:dazzify/features/booking/data/models/service_invoice_model.dart';
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart';
import 'package:dazzify/features/booking/data/requests/create_booking_request.dart';
import 'package:dazzify/features/booking/data/requests/validate_coupon_request.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'service_invoice_state.dart';

@Injectable()
class ServiceInvoiceCubit extends Cubit<ServiceInvoiceState> {
  final BookingRepository _repository;

  ServiceInvoiceCubit(
    this._repository,
  ) : super(const ServiceInvoiceState());

  Future<void> getBrandDeliveryFeesList({
    required String brandId,
  }) async {
    emit(state.copyWith(deliveryFeesState: UiState.loading));

    final result = await _repository.getBrandDeliveryFees(
      brandId: brandId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          deliveryFeesState: UiState.failure,
        ),
      ),
      (deliveryFeesList) {
        return emit(
          state.copyWith(
            deliveryFeesList: deliveryFeesList,
            deliveryFeesState: UiState.success,
          ),
        );
      },
    );
  }

  Future<void> validateCouponAndUpdateInvoice({
    required ServiceDetailsModel service,
    required String code,
    required num price,
  }) async {
    emit(state.copyWith(couponValidationState: UiState.loading));

    final result = await _repository.validateCoupon(
      brandId: service.brand.id,
      request: ValidateCouponRequest(
        code: code,
        purchaseAmount: price,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          couponValidationState: UiState.failure,
            invoice: state.invoice.updateInvoice(
              discountAmount: 0,
            )
        ),
      ),
      (coupon) {
        return emit(
          state.copyWith(
            couponModel: coupon,
            couponValidationState: UiState.success,
            invoice: state.invoice.updateInvoice(
              discountAmount: coupon.discountAmount,
            ),
          ),
        );
      },
    );
  }

  void clearCoupon() {
    emit(
      state.copyWith(
        couponValidationState: UiState.initial,
        couponModel: const CouponModel.empty(),
        invoice: state.invoice.updateInvoice(
          discountAmount: 0,
        ),
      ),
    );
  }

  void updateInvoice({
    List<num>? price,
    num? deliveryFees,
    num? discountAmount,
    List<num>? appFees,
  }) {
    emit(
      state.copyWith(
        invoice: state.invoice.updateInvoice(
          price: price,
          appFees: appFees,
          deliveryFees: deliveryFees,
          discountAmount: discountAmount,
        ),
      ),
    );
  }

  void updateSelectedLocation({
    required LocationModel selectedLocation,
  }) {
    emit(state.copyWith(
      selectedLocation: selectedLocation,
    ));
  }

  void updateSelectedLocationName({
    required String selectedLocationName,
  }) {
    emit(state.copyWith(
      selectedLocationName: selectedLocationName,
    ));
  }

  Future<void> bookService({
    required String brandId,
    required String branchId,
    required List<String> services,
    required List<Map<String, dynamic>>  servicesWithQuantity,
    required String date,
    required String startTimeStamp,
    required bool isHasCoupon,
    String? code,
    String? notes,
    LocationModel? bookingLocationModel,
    int? gov,
    bool? isInBranch,
  }) async {
    emit(
      state.copyWith(creatingBookingState: UiState.loading),
    );

    Map<String, double>? bookingLocation;
    if (bookingLocationModel != null) {
      bookingLocation = {
        AppConstants.longitude: bookingLocationModel.longitude,
        AppConstants.latitude: bookingLocationModel.latitude,
      };
    }

    debugPrint('---brandId: $brandId');
    debugPrint('---branchId: $branchId');
    debugPrint('---serviceId: ${services.first}');
    debugPrint('---startTime: $startTimeStamp');
    debugPrint('---isHasCoupon: $isHasCoupon');

    if (bookingLocation != null) {
      debugPrint('---bookingLocation: ${bookingLocation.entries}');
    }

    if (gov != null) {
      debugPrint('---gov: $gov');
    }

    if (code != null) {
      debugPrint('---couponCode: $code');
    }
    if (notes != null) {
      debugPrint('---notes: $notes');
    }

    if (isInBranch != null) {
      debugPrint('---isInBranch: $isInBranch');
    }

    Either<Failure, Unit> result = await _repository.createBooking(
      request: CreateBookingRequest(
        brandId: brandId,
        branchId: branchId,
        services: services,
        startTime: startTimeStamp,
        bookingLocation: bookingLocation,
        isHasCoupon: isHasCoupon,
        // code: couponId,
        code: code,
        notes: notes,
        gov: gov,
        isInBranch: isInBranch,
        servicesWithQuantity: servicesWithQuantity,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          creatingBookingState: UiState.failure,
        ),
      ),
      (unit) {
        // Track booking completion for TikTok
        TikTokSdkService.instance.logPurchase(
          value: state.invoice.totalAmount.toDouble(),
          currency: 'EGP',
          contentId: services.join(','),
          contentName: 'Booking Service',
        );
        
        emit(
          state.copyWith(
            creatingBookingState: UiState.success,
          ),
        );
      },
    );
  }

  void updateDeliveryInfo({required DeliveryInfoModel deliveryInfo}) {
    emit(state.copyWith(
      deliveryInfo: deliveryInfo,
    ));
  }
}
