import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'booking_from_media_state.dart';

@injectable
class BookingFromMediaCubit extends Cubit<BookingFromMediaState> {
  final BrandRepository _brandRepository;

  BookingFromMediaCubit(
    this._brandRepository,
  ) : super(const BookingFromMediaState());

  Future<void> getSingleServiceDetails({required String serviceId}) async {
    emit(state.copyWith(
      blocState: UiState.loading,
    ));

    final results = await _brandRepository.getSingleServiceDetails(
      serviceId: serviceId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (service) => emit(
        state.copyWith(
          blocState: UiState.success,
          service: service,
        ),
      ),
    );
  }
}
