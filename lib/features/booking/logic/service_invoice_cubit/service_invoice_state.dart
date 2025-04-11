part of 'service_invoice_cubit.dart';

class ServiceInvoiceState extends Equatable {
  final UiState deliveryFeesState;
  final UiState couponValidationState;
  final UiState creatingBookingState;
  final List<BrandDeliveryFeesModel> deliveryFeesList;
  final CouponModel couponModel;
  final String errorMessage;
  final DeliveryInfoModel deliveryInfo;
  final String selectedLocationName;
  final LocationModel selectedLocation;
  final ServiceInvoiceModel invoice;
  final num appFees;

  const ServiceInvoiceState({
    this.deliveryFeesState = UiState.initial,
    this.couponValidationState = UiState.initial,
    this.creatingBookingState = UiState.initial,
    this.deliveryFeesList = const [],
    this.couponModel = const CouponModel.empty(),
    this.errorMessage = '',
    this.deliveryInfo = const DeliveryInfoModel.empty(),
    this.selectedLocationName = '',
    this.selectedLocation = const LocationModel.empty(),
    this.invoice =  const ServiceInvoiceModel.empty([],[]),
    this.appFees = 0,
  });

  ServiceInvoiceState copyWith({
    UiState? deliveryFeesState,
    UiState? couponValidationState,
    UiState? creatingBookingState,
    List<BrandDeliveryFeesModel>? deliveryFeesList,
    CouponModel? couponModel,
    String? errorMessage,
    DeliveryInfoModel? deliveryInfo,
    String? selectedLocationName,
    LocationModel? selectedLocation,
    ServiceInvoiceModel? invoice,
    num? appFees,
  }) {
    return ServiceInvoiceState(
      deliveryFeesState: deliveryFeesState ?? this.deliveryFeesState,
      couponValidationState:
          couponValidationState ?? this.couponValidationState,
      creatingBookingState: creatingBookingState ?? this.creatingBookingState,
      deliveryFeesList: deliveryFeesList ?? this.deliveryFeesList,
      couponModel: couponModel ?? this.couponModel,
      errorMessage: errorMessage ?? this.errorMessage,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      selectedLocationName: selectedLocationName ?? this.selectedLocationName,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      invoice: invoice ?? this.invoice,
      appFees: appFees ?? this.appFees,
    );
  }

  @override
  List<Object> get props => [
        deliveryFeesState,
        couponValidationState,
        creatingBookingState,
        deliveryFeesList,
        couponModel,
        errorMessage,
        deliveryInfo,
        selectedLocationName,
        selectedLocation,
        invoice,
        appFees,
      ];
}
