import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/web_socket/repositories/web_socket_repository.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';
import 'package:dazzify/features/booking/data/models/booking_review_request_model.dart';
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart';
import 'package:dazzify/features/booking/data/requests/create_booking_review_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'booking_review_state.dart';

@injectable
class BookingReviewCubit extends Cubit<BookingReviewState> {
  final BookingRepository bookingRepository;
  final WebSocketRepository webSocketRepository;

  BookingReviewCubit(
    this.bookingRepository,
    this.webSocketRepository,
  ) : super(BookingReviewState()) {
    getMissedBookingReviewFromSocket();
  }

  Future<void> getMissedBookingReview() async {
    emit(state.copyWith(bookingReviewRequestState: UiState.loading));
    final response = await bookingRepository.getMissedReview();
    response.fold(
      (failure) {},
      (bookingReviewRequest) {
        emit(
          state.copyWith(
            bookingReviewRequestState: UiState.success,
            bookingReviewRequest: bookingReviewRequest,
          ),
        );
      },
    );
  }

  Future<void> addBookingReview(CreateBookingReviewRequest request) async {
    emit(state.copyWith(addReviewState: UiState.loading));
    final response = await bookingRepository.createBookingReview(
      request: request,
    );
    response.fold(
      (failure) {
        emit(
          state.copyWith(
            addReviewState: UiState.failure,
            addReviewError: failure.message,
            bookingReviewRequestState: UiState.initial,
          ),
        );
      },
      (bookingReviewRequest) {
        emit(state.copyWith(addReviewState: UiState.success));
      },
    );
  }

  Future<void> setNotInterestedToReview() async =>
      await bookingRepository.setNotInterestedToReview(
        bookingId: state.bookingReviewRequest.bookingId,
      );

  Future<void> getMissedBookingReviewFromSocket() async {
    webSocketRepository.socketEventPass().listen((WebSocketResponse response) {
      if (response.type == WebSocketDataType.review) {
        final BookingReviewRequestModel bookingReviewRequest = response.data;
        emit(
          state.copyWith(
              bookingReviewRequestState: UiState.success,
              bookingReviewRequest: bookingReviewRequest),
        );
      }
    });
  }
}
