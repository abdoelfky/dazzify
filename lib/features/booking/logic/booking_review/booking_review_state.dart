part of 'booking_review_cubit.dart';

class BookingReviewState extends Equatable {
  final BookingReviewRequestModel bookingReviewRequest;
  final UiState bookingReviewRequestState;
  final UiState addReviewState;
  final String addReviewError;
  final bool isSheetShowing;

  const BookingReviewState({
    this.bookingReviewRequest = const BookingReviewRequestModel.empty(),
    this.bookingReviewRequestState = UiState.initial,
    this.addReviewState = UiState.initial,
    this.addReviewError = "",
    this.isSheetShowing = false,
  });

  @override
  List<Object> get props => [
        bookingReviewRequest,
        bookingReviewRequestState,
        addReviewState,
        addReviewError,
        isSheetShowing,
      ];

  BookingReviewState copyWith({
    BookingReviewRequestModel? bookingReviewRequest,
    UiState? bookingReviewRequestState,
    UiState? addReviewState,
    String? addReviewError,
    bool? isSheetShowing,
  }) {
    return BookingReviewState(
      bookingReviewRequest: bookingReviewRequest ?? this.bookingReviewRequest,
      bookingReviewRequestState:
          bookingReviewRequestState ?? this.bookingReviewRequestState,
      addReviewState: addReviewState ?? this.addReviewState,
      addReviewError: addReviewError ?? this.addReviewError,
      isSheetShowing: isSheetShowing ?? this.isSheetShowing,
    );
  }
}
