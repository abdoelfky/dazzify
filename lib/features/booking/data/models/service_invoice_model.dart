import 'package:equatable/equatable.dart';

class ServiceInvoiceModel extends Equatable {
  final num price;
  final num deliveryFees;
  final num appFees;
  final num discountAmount;
  final num totalPrice;

  const ServiceInvoiceModel({
    required this.price,
    required this.deliveryFees,
    required this.appFees,
    required this.discountAmount,
  }) : totalPrice = price + deliveryFees + appFees - discountAmount;

  const ServiceInvoiceModel.empty([
    this.price = 0,
    this.deliveryFees = 0,
    this.appFees = 0,
    this.discountAmount = 0,
    this.totalPrice = 0,
  ]);

  ServiceInvoiceModel updateInvoice({
    num? price,
    num? deliveryFees,
    num? appFees,
    num? discountAmount,
  }) {
    num newPrice = price ?? this.price;
    num newDeliveryFees = deliveryFees ?? this.deliveryFees;
    num newAppFees = appFees ?? this.appFees;
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
