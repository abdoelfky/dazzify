import 'package:equatable/equatable.dart';

class ServiceInvoiceModel extends Equatable {
  final List<num> price;
  final num deliveryFees;
  final List<num> appFees;
  final num discountAmount;
  final num totalPrice;

  // Removed const from constructor to allow runtime calculations
  ServiceInvoiceModel({
    required this.price,
    required this.deliveryFees,
    required this.appFees,
    required this.discountAmount,
  }) : totalPrice = price.fold<num>(0, (sum, item) => sum + item) + deliveryFees + appFees.fold<num>(0, (sum, item) => sum + item) - discountAmount;

  // Non-constant constructor for empty values
  const ServiceInvoiceModel.empty(this.price,this.appFees)
      :
        deliveryFees = 0,
        discountAmount = 0,
        totalPrice = 0;

  // Update method
  ServiceInvoiceModel updateInvoice({
    List<num>? price,
    num? deliveryFees,
    List<num>? appFees,
    num? discountAmount,
  }) {
    List<num> newPrice = price ?? this.price;
    num newDeliveryFees = deliveryFees ?? this.deliveryFees;
    List<num> newAppFees = appFees ?? this.appFees;
    num newDiscountAmount = discountAmount ?? this.discountAmount;

    return ServiceInvoiceModel(
      price: newPrice,
      deliveryFees: newDeliveryFees,
      appFees: newAppFees,
      discountAmount: newDiscountAmount,
    );
  }

  @override
  List<Object> get props => [
    price,
    deliveryFees,
    appFees,
    discountAmount,
    totalPrice,
  ];
}
