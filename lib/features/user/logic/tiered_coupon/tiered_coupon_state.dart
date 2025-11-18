import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/user/data/models/tiered_coupon/tiered_coupon_model.dart';
import 'package:equatable/equatable.dart';

class TieredCouponState extends Equatable {
  final UiState uiState;
  final List<TieredCouponModel> coupons;
  final String errorMessage;
  final int? selectedCouponIndex;

  const TieredCouponState({
    this.uiState = UiState.initial,
    this.coupons = const [],
    this.errorMessage = '',
    this.selectedCouponIndex,
  });

  TieredCouponState copyWith({
    UiState? uiState,
    List<TieredCouponModel>? coupons,
    String? errorMessage,
    int? selectedCouponIndex,
    bool clearSelection = false,
  }) {
    return TieredCouponState(
      uiState: uiState ?? this.uiState,
      coupons: coupons ?? this.coupons,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCouponIndex: clearSelection ? null : (selectedCouponIndex ?? this.selectedCouponIndex),
    );
  }

  @override
  List<Object?> get props => [
        uiState,
        coupons,
        errorMessage,
        selectedCouponIndex,
      ];
}
