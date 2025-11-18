import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/user/data/models/tiered_coupon/tiered_coupon_model.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
import 'package:dazzify/features/user/logic/tiered_coupon/tiered_coupon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TieredCouponCubit extends Cubit<TieredCouponState> {
  final UserRepository _userRepository;

  TieredCouponCubit(this._userRepository)
      : super(const TieredCouponState());

  Future<void> getTieredCouponRewards() async {
    emit(state.copyWith(uiState: UiState.loading));

    final result = await _userRepository.getTieredCouponRewards();

    result.fold(
      (failure) => emit(
        state.copyWith(
          uiState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (coupons) {
        // Sort coupons by level number
        final sortedCoupons = List.of(coupons)
          ..sort((a, b) => a.levelNumber.compareTo(b.levelNumber));
        
        emit(
          state.copyWith(
            uiState: UiState.success,
            coupons: sortedCoupons,
          ),
        );
      },
    );
  }

  void selectCoupon(int index) {
    final coupon = state.coupons[index];
    // Only allow selection if the coupon is not locked
    if (!coupon.locked) {
      emit(state.copyWith(selectedCouponIndex: index));
    }
  }

  void clearSelection() {
    emit(state.copyWith(clearSelection: true));
  }

  Future<void> markCouponAsOpened(int index) async {
    final updatedCoupons = List<TieredCouponModel>.from(state.coupons);
    final coupon = updatedCoupons[index];
    
    // If code is null, call API to get new code
    String? newCode = coupon.code;
    
    if (newCode == null) {
      final result = await _userRepository.openNewRewardLevel(
        levelNumber: coupon.levelNumber,
      );
      
      result.fold(
        (failure) {
          // Handle error - maybe show a message
          // For now, we'll just mark as opened without code
        },
        (response) {
          // Extract code from response
          final data = response['data'] as Map<String, dynamic>?;
          if (data != null && data['code'] != null) {
            newCode = data['code'] as String;
          }
        },
      );
    }
    
    // Create a new coupon with opened = true and updated code
    final openedCoupon = coupon.copyWith(
      code: newCode,
      opened: true,
    );
    
    updatedCoupons[index] = openedCoupon;
    emit(state.copyWith(coupons: updatedCoupons));
  }
}
