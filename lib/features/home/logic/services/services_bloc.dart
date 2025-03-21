import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/get_services_request.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'services_event.dart';
part 'services_state.dart';

@Injectable()
class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final HomeRepository _homeRepository;

  int _popularServicesPage = 1;
  int _topRatedServicesPage = 1;
  final int _popularServicesLimit = 20;
  final int _topRatedServicesLimit = 20;

  ServicesBloc(
    this._homeRepository,
  ) : super(const ServicesState()) {
    on<GetPopularServicesEvent>(
      _onGetPopularServices,
      transformer: droppable(),
    );
    on<GetTopRatedServicesEvent>(
      _onGetTopRatedServices,
      transformer: droppable(),
    );
  }

  Future<void> _onGetPopularServices(
      GetPopularServicesEvent event, Emitter<ServicesState> emit) async {
    if (!state.hasPopularServicesReachedMax) {
      if (state.popularServices.isEmpty) {
        emit(state.copyWith(popularServicesState: UiState.loading));
      }

      Either<Failure, List<ServiceDetailsModel>> result =
          await _homeRepository.getPopularServices(
        request: GetServicesRequest(
          page: _popularServicesPage,
          limit: _popularServicesLimit,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            popularServicesState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (popularServices) {
          final hasReachedMax = popularServices.isEmpty ||
              popularServices.length < _popularServicesLimit;
          emit(
            state.copyWith(
              popularServices: List.of(state.popularServices)
                ..addAll(popularServices),
              popularServicesState: UiState.success,
              hasPopularServicesReachedMax: hasReachedMax,
            ),
          );
          _popularServicesPage++;
        },
      );
    }
  }

  Future<void> _onGetTopRatedServices(
      GetTopRatedServicesEvent event, Emitter<ServicesState> emit) async {
    if (!state.hasTopRatedServicesReachedMax) {
      if (state.topRatedServices.isEmpty) {
        emit(state.copyWith(topRatedServicesState: UiState.loading));
      }

      Either<Failure, List<ServiceDetailsModel>> result =
          await _homeRepository.getTopRatedServices(
        request: GetServicesRequest(
          page: _topRatedServicesPage,
          limit: _topRatedServicesLimit,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            topRatedServicesState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (topRatedServices) {
          final hasReachedMax = topRatedServices.isEmpty ||
              topRatedServices.length < _topRatedServicesLimit;
          emit(
            state.copyWith(
              topRatedServices: List.of(state.topRatedServices)
                ..addAll(topRatedServices),
              topRatedServicesState: UiState.success,
              hasTopRatedServicesReachedMax: hasReachedMax,
            ),
          );
          _topRatedServicesPage++;
        },
      );
    }
  }
}
