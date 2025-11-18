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

  void markCouponAsOpened(int index) {
    final updatedCoupons = List<TieredCouponModel>.from(state.coupons);
    final coupon = updatedCoupons[index];
    
    // Create a new coupon with opened = true
    final openedCoupon = TieredCouponModel(
      code: coupon.code,
      opened: true,
      locked: coupon.locked,
      levelNumber: coupon.levelNumber,
      discountPercentage: coupon.discountPercentage,
      color: coupon.color,
      instructions: coupon.instructions,
    );
    
    updatedCoupons[index] = openedCoupon;
    emit(state.copyWith(coupons: updatedCoupons));
  }

  Future<void> openNewRewardLevel(int index) async {
    final result = await _userRepository.openNewRewardLevel();
    
    result.fold(
      (failure) {
        // Handle error silently or you can emit error state if needed
      },
      (response) {
        final updatedCoupons = List<TieredCouponModel>.from(state.coupons);
        final currentCoupon = updatedCoupons[index];
        
        // Create a new coupon with the code from API and mark as opened
        final openedCoupon = TieredCouponModel(
          code: response.code,
          opened: true,
          locked: currentCoupon.locked,
          levelNumber: currentCoupon.levelNumber,
          discountPercentage: currentCoupon.discountPercentage,
          color: currentCoupon.color,
          instructions: currentCoupon.instructions,
        );
        
        updatedCoupons[index] = openedCoupon;
        emit(state.copyWith(coupons: updatedCoupons));
      },
    );
  }
}
