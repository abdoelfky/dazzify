import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/web_socket/repositories/web_socket_repository.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';
import 'package:dazzify/features/booking/data/models/booking_rate_model.dart';
import 'package:dazzify/features/booking/data/models/branch_info_model.dart';
import 'package:dazzify/features/booking/data/models/last_active_booking_model.dart';
import 'package:dazzify/features/booking/data/models/service_location_model.dart';
import 'package:dazzify/features/booking/data/models/single_booking_model.dart';
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart';
import 'package:dazzify/features/booking/data/requests/create_booking_review_request.dart';
import 'package:dazzify/features/booking/data/requests/user_arrived_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

part 'booking_state.dart';

@injectable
class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;
  final WebSocketRepository _webSocketRepository;

  BookingCubit(
    this._bookingRepository,
    this._webSocketRepository,
  ) : super(const BookingState()) {
    _startWebsocketConnection();
  }

  Future<void> getSingleBooking(String bookingId) async {
    emit(state.copyWith(singleBookingState: UiState.loading));

    final Either<Failure, SingleBookingModel> result =
        await _bookingRepository.getSingleBooking(
      bookingId: bookingId,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        singleBookingState: UiState.failure,
        errorMessage: failure.message,
      )),
      (singleBooking) => emit(state.copyWith(
        singleBookingState: UiState.success,
        singleBooking: singleBooking,
      )),
    );
  }

  Future<void> cancelBooking() async {
    emit(state.copyWith(cancelBookingState: UiState.loading));

    final canceledBooking = await _bookingRepository.cancelBooking(
      bookingId: state.singleBooking.id,
    );

    canceledBooking.fold(
      (failure) => emit(
        state.copyWith(
          cancelBookingState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        final updatedBooking =
            state.singleBooking.copyWith(status: "cancelled");
        emit(
          state.copyWith(
            cancelBookingState: UiState.success,
            singleBooking: updatedBooking,
          ),
        );
      },
    );
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.deniedForever:
        emit(
          state.copyWith(
              locationPermissionsState: PermissionsState.permanentlyDenied),
        );
        return;
      case LocationPermission.denied:
        emit(state.copyWith(locationPermissionsState: PermissionsState.denied));
        permission = await Geolocator.requestPermission();
        break;
      case LocationPermission.unableToDetermine:
        emit(state.copyWith(locationPermissionsState: PermissionsState.denied));
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always) {
          emit(
            state.copyWith(
              locationPermissionsState: PermissionsState.granted,
            ),
          );
        }
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        emit(
          state.copyWith(locationPermissionsState: PermissionsState.granted),
        );

        break;
    }
  }

  Future<void> userArrived() async {
    await checkLocationPermission();
    if (state.locationPermissionsState == PermissionsState.granted) {
      emit(state.copyWith(userArrivedState: UiState.loading));
      final location = await Geolocator.getCurrentPosition();
      final userArrived = await _bookingRepository.userArrived(
        bookingId: state.singleBooking.id,
        request: UserArrivedRequest(
          longitude: location.longitude,
          latitude: location.latitude,
        ),
      );
      userArrived.fold(
        (failure) => emit(
          state.copyWith(
            userArrivedState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (success) {
          final updatedBooking = state.singleBooking.copyWith(
            isArrived: true,
          );
          emit(
            state.copyWith(
              singleBooking: updatedBooking,
              userArrivedState: UiState.success,
            ),
          );
        },
      );
    }
  }

  Future<void> createReview({
    required String comment,
    required double rate,
  }) async {
    emit(state.copyWith(createReviewState: UiState.loading));

    final review = await _bookingRepository.createBookingReview(
      request: CreateBookingReviewRequest(
        bookingId: state.singleBooking.id,
        comment: comment,
        rate: rate,
      ),
    );
    review.fold(
      (failure) => emit(
        state.copyWith(
          createReviewState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        final updatedRate = state.singleBooking.rating.copyWith(
          rate: rate,
          comment: comment,
        );
        final updatedBooking =
            state.singleBooking.copyWith(rating: updatedRate);
        emit(
          state.copyWith(
            singleBooking: updatedBooking,
            createReviewState: UiState.success,
          ),
        );
      },
    );
  }

  Future<void> getLastActiveBookings() async {
    emit(state.copyWith(lastActiveBookingState: UiState.loading));

    final result = await _bookingRepository.getLastActiveBookings();
    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          lastActiveBookingState: UiState.failure,
        ),
      ),
      (lastActiveBookings) => emit(
        state.copyWith(
          lastActiveBookings: lastActiveBookings,
          lastActiveBookingState: UiState.success,
        ),
      ),
    );
  }

  void _startWebsocketConnection() async {
    _webSocketRepository.socketEventPass().listen(
      (WebSocketResponse response) async {
        if (response.type == WebSocketDataType.booking) {
          emit(state.copyWith(lastActiveBookingState: UiState.loading));
          await Future.delayed(Duration(seconds: 1));
          emit(
            state.copyWith(
              lastActiveBookings: response.data,
              lastActiveBookingState: UiState.success,
            ),
          );
        }
      },
    );
  }
}
