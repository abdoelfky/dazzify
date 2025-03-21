// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'booking_history_bloc.dart';

class BookingHistoryState extends Equatable {
  final UiState bookingsHistoryState;
  final List<BookingsListModel> bookingsHistory;
  final String errorMessage;
  final bool hasReachedMax;

  const BookingHistoryState({
    this.bookingsHistoryState = UiState.initial,
    this.bookingsHistory = const [],
    this.hasReachedMax = false,
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [
        bookingsHistoryState,
        bookingsHistory,
        errorMessage,
        hasReachedMax,
      ];

  BookingHistoryState copyWith({
    UiState? bookingsHistoryState,
    List<BookingsListModel>? bookingsHistory,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return BookingHistoryState(
      bookingsHistoryState: bookingsHistoryState ?? this.bookingsHistoryState,
      bookingsHistory: bookingsHistory ?? this.bookingsHistory,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
