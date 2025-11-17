import 'package:equatable/equatable.dart';

class DeliveryInfoModel extends Equatable {
  final num selectedDeliveryFees;
  final int selectedGov;
  final bool isRangeType;
  final num? minDeliveryFees;
  final num? maxDeliveryFees;

  const DeliveryInfoModel({
    required this.selectedDeliveryFees,
    required this.selectedGov,
    this.isRangeType = false,
    this.minDeliveryFees,
    this.maxDeliveryFees,
  });

  const DeliveryInfoModel.empty([
    this.selectedDeliveryFees = 0,
    this.selectedGov = 0,
    this.isRangeType = false,
    this.minDeliveryFees,
    this.maxDeliveryFees,
  ]);

  @override
  List<Object?> get props => [
        selectedDeliveryFees,
        selectedGov,
        isRangeType,
        minDeliveryFees,
        maxDeliveryFees,
      ];
}
