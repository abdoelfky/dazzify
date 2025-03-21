part of 'booking_cubit.dart';

class BookingState extends Equatable {
  // States
  final UiState singleBookingState;
  final UiState cancelBookingState;
  final UiState userArrivedState;
  final UiState createReviewState;
  final UiState lastActiveBookingState;
  final PermissionsState locationPermissionsState;

  // Data
  final SingleBookingModel singleBooking;
  final List<LastActiveBookingModel> lastActiveBookings;

  // Error
  final String errorMessage;

  const BookingState({
    this.singleBookingState = UiState.initial,
    this.cancelBookingState = UiState.initial,
    this.userArrivedState = UiState.initial,
    this.createReviewState = UiState.initial,
    this.lastActiveBookingState = UiState.initial,
    this.locationPermissionsState = PermissionsState.initial,
    this.lastActiveBookings = const [],
    this.singleBooking = const SingleBookingModel(
      id: '',
      startTime: '',
      endTime: '',
      isInBranch: false,
      isHasCoupon: false,
      price: 0,
      couponDis: 0,
      fees: 0,
      deliveryFees: 0,
      totalPrice: 0,
      status: '',
      isFinished: false,
      isRate: false,
      isArrived: false,
      brand: BrandModel.empty(),
      services: [],
      rating: BookingRateModel(
        comment: '',
        rate: 0,
      ),
      branch: BranchInfoModel(
        id: '',
        name: '',
        longitude: 0.0,
        latitude: 0.0,
      ),
      bookingLocation: ServiceLocationModel(
        name: '',
        longitude: 0.0,
        latitude: 0.0,
      ),
    ),
    this.errorMessage = "",
  });

  BookingState copyWith({
    UiState? singleBookingState,
    UiState? cancelBookingState,
    UiState? userArrivedState,
    UiState? createReviewState,
    UiState? lastActiveBookingState,
    PermissionsState? locationPermissionsState,
    SingleBookingModel? singleBooking,
    List<LastActiveBookingModel>? lastActiveBookings,
    String? errorMessage,
  }) {
    return BookingState(
      singleBookingState: singleBookingState ?? this.singleBookingState,
      cancelBookingState: cancelBookingState ?? this.cancelBookingState,
      userArrivedState: userArrivedState ?? this.userArrivedState,
      createReviewState: createReviewState ?? this.createReviewState,
      lastActiveBookingState:
          lastActiveBookingState ?? this.lastActiveBookingState,
      locationPermissionsState:
          locationPermissionsState ?? this.locationPermissionsState,
      singleBooking: singleBooking ?? this.singleBooking,
      lastActiveBookings: lastActiveBookings ?? this.lastActiveBookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        singleBookingState,
        cancelBookingState,
        locationPermissionsState,
        lastActiveBookings,
        userArrivedState,
        createReviewState,
        lastActiveBookingState,
        singleBooking,
        lastActiveBookings,
        errorMessage,
      ];
}
