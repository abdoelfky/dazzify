import 'package:equatable/equatable.dart';
import 'package:dazzify/core/util/app_config_manager.dart';

class ServiceInvoiceModel extends Equatable {
  final List<num> price;
  final num deliveryFees;
  final List<num> appFees;
  final num discountAmount;
  final num totalPrice;

  ServiceInvoiceModel({
    required this.price,
    required this.deliveryFees,
    required this.appFees,
    required this.discountAmount,
  }) : totalPrice = _calculateTotal(price, deliveryFees, appFees, discountAmount);

  static num _calculateTotal(List<num> price, num deliveryFees, List<num> appFees, num discountAmount) {
    final num servicesSum = price.fold<num>(0, (sum, item) => sum + item);
    final num rawAppFees = (servicesSum + deliveryFees) * AppConfigManager.appFeesPercentage;
    final num clampedAppFee = rawAppFees.clamp(AppConfigManager.appFeesMin, AppConfigManager.appFeesMax);

    return servicesSum + deliveryFees + clampedAppFee - discountAmount;
  }

  const ServiceInvoiceModel.empty(this.price, this.appFees)
      : deliveryFees = 0,
        discountAmount = 0,
        totalPrice = 0;

  ServiceInvoiceModel updateInvoice({
    List<num>? price,
    num? deliveryFees,
    List<num>? appFees,
    num? discountAmount,
  }) {
    return ServiceInvoiceModel(
      price: price ?? this.price,
      deliveryFees: deliveryFees ?? this.deliveryFees,
      appFees: appFees ?? this.appFees,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  @override
  List<Object> get props => [price, deliveryFees, appFees, discountAmount, totalPrice];
}
