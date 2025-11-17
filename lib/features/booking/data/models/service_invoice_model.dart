import 'package:equatable/equatable.dart';
import 'package:dazzify/core/util/app_config_manager.dart';

class TransportationFeesRange {
  final num min;
  final num max;

  const TransportationFeesRange({
    required this.min,
    required this.max,
  });

  const TransportationFeesRange.empty()
      : min = 0,
        max = 0;
}

class ServiceInvoiceModel extends Equatable {
  final List<num> price;
  final num deliveryFees;
  final TransportationFeesRange? transportationFeesRange;
  final List<num> appFees;
  final num discountAmount;
  final num totalPrice;
  final bool isRangeType;

  ServiceInvoiceModel({
    required this.price,
    required this.deliveryFees,
    this.transportationFeesRange,
    required this.appFees,
    required this.discountAmount,
  })  : isRangeType = transportationFeesRange != null,
        totalPrice = _calculateTotal(price, deliveryFees, appFees, discountAmount, transportationFeesRange);

  static num _calculateTotal(
    List<num> price,
    num deliveryFees,
    List<num> appFees,
    num discountAmount,
    TransportationFeesRange? transportationFeesRange,
  ) {
    final num servicesSum = price.fold<num>(0, (sum, item) => sum + item);

    // If range type, don't include delivery fees and app fees in total
    if (transportationFeesRange != null) {
      return servicesSum - discountAmount;
    }

    // Fixed type: calculate normally
    final num rawAppFees = (servicesSum + deliveryFees) * AppConfigManager.appFeesPercentage;
    final num clampedAppFee = rawAppFees.clamp(AppConfigManager.appFeesMin, AppConfigManager.appFeesMax);

    return servicesSum + deliveryFees + clampedAppFee - discountAmount;
  }

  const ServiceInvoiceModel.empty(this.price, this.appFees)
      : deliveryFees = 0,
        transportationFeesRange = null,
        discountAmount = 0,
        totalPrice = 0,
        isRangeType = false;

  ServiceInvoiceModel updateInvoice({
    List<num>? price,
    num? deliveryFees,
    TransportationFeesRange? transportationFeesRange,
    List<num>? appFees,
    num? discountAmount,
  }) {
    return ServiceInvoiceModel(
      price: price ?? this.price,
      deliveryFees: deliveryFees ?? this.deliveryFees,
      transportationFeesRange: transportationFeesRange ?? this.transportationFeesRange,
      appFees: appFees ?? this.appFees,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  @override
  List<Object?> get props => [price, deliveryFees, transportationFeesRange, appFees, discountAmount, totalPrice, isRangeType];
}
