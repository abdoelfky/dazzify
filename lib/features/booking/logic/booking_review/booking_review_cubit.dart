import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/web_socket/repositories/web_socket_repository.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart';
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
  final AuthLocalDatasource authLocalDatasource;
  StreamSubscription<WebSocketResponse>? _socketSubscription;

  BookingReviewCubit(
    this.bookingRepository,
    this.webSocketRepository,
    this.authLocalDatasource,
  ) : super(BookingReviewState()) {
    // Only subscribe to websocket if not in guest mode
    if (!authLocalDatasource.checkGuestMode()) {
      getMissedBookingReviewFromSocket();
    }
  }

  Future<void> getMissedBookingReview() async {
    // Skip fetching missed reviews if in guest mode
    if (authLocalDatasource.checkGuestMode()) {
      emit(state.copyWith(bookingReviewRequestState: UiState.success));
      return;
    }

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
    emit(state.copyWith(bookingReviewRequestState: UiState.initial));
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
        emit(state.copyWith(
            addReviewState: UiState.success,
            bookingReviewRequest: BookingReviewRequestModel.empty(),
            bookingReviewRequestState: UiState.initial));
      },
    );
  }

  Future<void> setNotInterestedToReview() async =>
      await bookingRepository.setNotInterestedToReview(
        bookingId: state.bookingReviewRequest.bookingId,
      );

  Future<void> getMissedBookingReviewFromSocket() async {
    // Cancel existing subscription to prevent duplicates
    await _socketSubscription?.cancel();
    
    _socketSubscription = webSocketRepository.socketEventPass().listen((WebSocketResponse response) {
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

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    return super.close();
  }
}
