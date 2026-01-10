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
        
        // Preserve opened state from current state and set opened=true if code exists
        final currentCoupons = state.coupons;
        final mergedCoupons = sortedCoupons.asMap().entries.map((entry) {
          final index = entry.key;
          final newCoupon = entry.value;
          
          // If we have a current coupon at this index, preserve its opened state
          // Also, if the new coupon from API has a code, it means it was opened
          bool shouldBeOpened = false;
          if (index < currentCoupons.length) {
            final currentCoupon = currentCoupons[index];
            // Preserve opened state from current OR if new coupon has a code
            shouldBeOpened = currentCoupon.opened || 
                            (newCoupon.code != null && newCoupon.code!.isNotEmpty);
          } else {
            // New coupon - if it has a code, it was opened
            shouldBeOpened = newCoupon.code != null && newCoupon.code!.isNotEmpty;
          }
          
          return TieredCouponModel(
            code: newCoupon.code,
            opened: shouldBeOpened,
            locked: newCoupon.locked,
            levelNumber: newCoupon.levelNumber,
            discountPercentage: newCoupon.discountPercentage,
            color: newCoupon.color,
            instructions: newCoupon.instructions,
          );
        }).toList();
        
        emit(
          state.copyWith(
            uiState: UiState.success,
            coupons: mergedCoupons,
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
        
        // Only update if not already opened (prevent race condition)
        if (!currentCoupon.opened) {
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
        }
        
        // Fetch updated rewards list in background (don't wait for it)
        _refreshRewardsInBackground();
      },
    );
  }

  // Called when scratch threshold is reached - just marks as opened
  void markCouponAsOpenedOnThreshold(int index) {
    final updatedCoupons = List<TieredCouponModel>.from(state.coupons);
    final coupon = updatedCoupons[index];
    
    // Only mark as opened if we have a code (ensure code was fetched)
    // This prevents showing scratch overlay again if code fetch is still pending
    if (coupon.code != null && coupon.code!.isNotEmpty) {
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
        
        // Merge: Keep opened state from current if it exists, or set opened=true if code exists
        final mergedCoupons = sortedNewCoupons.asMap().entries.map((entry) {
          final index = entry.key;
          final newCoupon = entry.value;
          
          // If we have a current coupon at this index, preserve its opened state
          // Also, if the new coupon from API has a code, it means it was opened
          bool shouldBeOpened = false;
          if (index < currentCoupons.length) {
            final currentCoupon = currentCoupons[index];
            // Preserve opened state from current OR if new coupon has a code
            shouldBeOpened = currentCoupon.opened || 
                            (newCoupon.code != null && newCoupon.code!.isNotEmpty);
          } else {
            // New coupon - if it has a code, it was opened
            shouldBeOpened = newCoupon.code != null && newCoupon.code!.isNotEmpty;
          }
          
          return TieredCouponModel(
            code: newCoupon.code,
            opened: shouldBeOpened,
            locked: newCoupon.locked,
            levelNumber: newCoupon.levelNumber,
            discountPercentage: newCoupon.discountPercentage,
            color: newCoupon.color,
            instructions: newCoupon.instructions,
          );
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
