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

  // Called when user starts scratching - fetches the real code immediately
  Future<void> fetchCouponCodeOnScratchStart(int index) async {
    final result = await _userRepository.openNewRewardLevel();
    
    result.fold(
      (failure) {
        // Handle error silently - user can continue scratching
      },
      (coupon) {
        final updatedCoupons = List<TieredCouponModel>.from(state.coupons);
        final currentCoupon = updatedCoupons[index];
        
        // Update ONLY the code, keep opened=false so scratch continues
        final updatedCoupon = TieredCouponModel(
          code: coupon.code,
          opened: false, // Keep as not opened yet
          locked: currentCoupon.locked,
          levelNumber: currentCoupon.levelNumber,
          discountPercentage: currentCoupon.discountPercentage,
          color: currentCoupon.color,
          instructions: currentCoupon.instructions,
        );
        
        updatedCoupons[index] = updatedCoupon;
        emit(state.copyWith(coupons: updatedCoupons));
        
        // Fetch updated rewards list in background (don't wait for it)
        _refreshRewardsInBackground();
      },
    );
  }

  // Called when scratch threshold is reached - just marks as opened
  void markCouponAsOpenedOnThreshold(int index) {
    final updatedCoupons = List<TieredCouponModel>.from(state.coupons);
    final coupon = updatedCoupons[index];
    
    // Mark as opened - the code is already there from fetchCouponCodeOnScratchStart
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

  // Refresh rewards data in background without changing UI state
  Future<void> _refreshRewardsInBackground() async {
    final result = await _userRepository.getTieredCouponRewards();
    
    result.fold(
      (failure) {
        // Silently ignore errors during background refresh
      },
      (coupons) {
        // Update the coupons list but maintain current opened states
        final currentCoupons = state.coupons;
        final sortedNewCoupons = List.of(coupons)
          ..sort((a, b) => a.levelNumber.compareTo(b.levelNumber));
        
        // Merge: Keep opened state from current if it exists
        final mergedCoupons = sortedNewCoupons.asMap().entries.map((entry) {
          final index = entry.key;
          final newCoupon = entry.value;
          
          // If we have a current coupon at this index, preserve its opened state
          if (index < currentCoupons.length) {
            final currentCoupon = currentCoupons[index];
            return TieredCouponModel(
              code: newCoupon.code,
              opened: currentCoupon.opened, // Preserve opened state
              locked: newCoupon.locked,
              levelNumber: newCoupon.levelNumber,
              discountPercentage: newCoupon.discountPercentage,
              color: newCoupon.color,
              instructions: newCoupon.instructions,
            );
          }
          
          return newCoupon;
        }).toList();
        
        emit(state.copyWith(coupons: mergedCoupons));
      },
    );
  }

  // Legacy method - kept for backward compatibility if needed elsewhere
  Future<void> openNewRewardLevel(int index) async {
    final result = await _userRepository.openNewRewardLevel();
    
    result.fold(
      (failure) {
        // Handle error silently or you can emit error state if needed
      },
      (coupon) {
        final updatedCoupons = List<TieredCouponModel>.from(state.coupons);
        
        // Create a new coupon with the returned data and mark as opened
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
      },
    );
  }
}
