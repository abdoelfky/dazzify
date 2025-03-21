import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/booking/data/models/bookings_list_model.dart';
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart';
import 'package:dazzify/features/booking/data/requests/get_bookings_list_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'booking_history_event.dart';
part 'booking_history_state.dart';

@injectable
class BookingHistoryBloc
    extends Bloc<BookingHistoryEvent, BookingHistoryState> {
  final BookingRepository _bookingRepository;
  int _page = 1;
  final int _limit = 20;

  BookingHistoryBloc(
    this._bookingRepository,
  ) : super(const BookingHistoryState()) {
    on<GetBookingHistoryEvent>(
      _onGetBookingHistoryEvent,
      transformer: droppable(),
    );
  }

  Future<void> _onGetBookingHistoryEvent(
      GetBookingHistoryEvent event, Emitter<BookingHistoryState> emit) async {
    if (!state.hasReachedMax) {
      if (state.bookingsHistory.isEmpty) {
        emit(state.copyWith(bookingsHistoryState: UiState.loading));
      }

      final Either<Failure, List<BookingsListModel>> result =
          await _bookingRepository.getBookingsList(
        request: GetBookingsListRequest(
          page: _page,
          limit: _limit,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          bookingsHistoryState: UiState.failure,
          errorMessage: failure.message,
        )),
        (bookingsHistory) {
          final hasReachedMax =
              bookingsHistory.isEmpty || bookingsHistory.length < _limit;
          emit(
            state.copyWith(
              bookingsHistory: List.of(state.bookingsHistory)
                ..addAll(bookingsHistory),
              bookingsHistoryState: UiState.success,
              hasReachedMax: hasReachedMax,
            ),
          );
          _page++;
        },
      );
    }
  }
}
