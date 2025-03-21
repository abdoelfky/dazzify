part of 'booking_from_media_cubit.dart';

class BookingFromMediaState extends Equatable {
  final UiState blocState;
  final ServiceDetailsModel service;
  final String errorMessage;

  const BookingFromMediaState({
    this.blocState = UiState.initial,
    this.service = const ServiceDetailsModel.empty(),
    this.errorMessage = '',
  });

  BookingFromMediaState copyWith({
    UiState? blocState,
    ServiceDetailsModel? service,
    String? errorMessage,
  }) {
    return BookingFromMediaState(
      blocState: blocState ?? this.blocState,
      service: service ?? this.service,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        blocState,
        service,
        errorMessage,
      ];
}
