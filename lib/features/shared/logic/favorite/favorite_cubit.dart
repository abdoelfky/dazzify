import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart';
import 'package:dazzify/features/shared/data/models/favorite_model.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'favorite_state.dart';

@injectable
class FavoriteCubit extends Cubit<FavoriteState> {
  final UserRepository _userRepository;
  final AuthLocalDatasource _authLocalDatasource;

  FavoriteCubit(
    this._userRepository,
    this._authLocalDatasource,
  ) : super(const FavoriteState());

  Future<void> getFavoriteModels() async {
    // Skip fetching favorites if in guest mode
    if (_authLocalDatasource.checkGuestMode()) {
      emit(state.copyWith(blocState: UiState.success));
      return;
    }

    final result = await _userRepository.getFavoriteModels();

    result.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (favoriteModels) {
        emit(
          state.copyWith(
            blocState: UiState.success,
            favoriteServiceList: favoriteModels,
          ),
        );
      },
    );
  }

  Future<void> getFavoriteIds() async {
    // Skip fetching favorite IDs if in guest mode
    if (_authLocalDatasource.checkGuestMode()) {
      emit(state.copyWith(blocState: UiState.success));
      return;
    }

    final result = await _userRepository.getFavoriteIds();

    result.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (favoriteIdList) => emit(
        state.copyWith(
          blocState: UiState.success,
          favoriteIds: favoriteIdList.toSet(),
        ),
      ),
    );
  }

  Future<void> addOrRemoveFromFavorite(
      {required FavoriteModel favoriteService}) async {
    if (state.favoriteIds.contains(favoriteService.id)) {
      _removeFavorite(favoriteService: favoriteService);
    } else {
      _addFavorite(favoriteService: favoriteService);
    }
  }

  Future<void> _addFavorite({required FavoriteModel favoriteService}) async {
    emit(state.copyWith(
      favoriteIds: Set.from(state.favoriteIds)..add(favoriteService.id),
      favoriteServiceList: List.from(state.favoriteServiceList)
        ..add(favoriteService),
      blocState: UiState.loading,
    ));

    Either<Failure, Unit> result = await _userRepository.addFavorite(
      serviceId: favoriteService.id,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            blocState: UiState.success,
          ),
        );
      },
    );
  }

  Future<void> _removeFavorite({required FavoriteModel favoriteService}) async {
    emit(state.copyWith(
      favoriteIds: Set.from(state.favoriteIds)..remove(favoriteService.id),
      favoriteServiceList: List.from(
        state.favoriteServiceList
          ..removeWhere(
            (element) => element.id == favoriteService.id,
          ),
      ),
      blocState: UiState.loading,
    ));

    final result = await _userRepository.removeFavorite(
      serviceId: favoriteService.id,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            blocState: UiState.success,
          ),
        );
      },
    );
  }
}
