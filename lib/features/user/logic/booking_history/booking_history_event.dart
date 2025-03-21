part of 'booking_history_bloc.dart';

sealed class BookingHistoryEvent extends Equatable {
  const BookingHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetBookingHistoryEvent extends BookingHistoryEvent {
  const GetBookingHistoryEvent();

  @override
  List<Object> get props => [];
}
