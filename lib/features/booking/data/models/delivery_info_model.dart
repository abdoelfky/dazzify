import 'package:equatable/equatable.dart';

class DeliveryInfoModel extends Equatable {
  final num selectedDeliveryFees;
  final int selectedGov;

  const DeliveryInfoModel({
    required this.selectedDeliveryFees,
    required this.selectedGov,
  });

  const DeliveryInfoModel.empty([
    this.selectedDeliveryFees = 0,
    this.selectedGov = 0,
  ]);

  @override
  List<Object?> get props => [
        selectedDeliveryFees,
        selectedGov,
      ];
}
