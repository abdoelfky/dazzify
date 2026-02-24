import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/models/brand_recommendation_history_model.dart';
import 'package:dazzify/features/home/data/models/brand_recommendation_model.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'brand_recommendation_history_state.dart';

@injectable
class BrandRecommendationHistoryCubit extends Cubit<BrandRecommendationHistoryState> {
  final HomeRepository _repository;
  int _currentPage = 1;
  final int _limit = 25;
  bool _hasReachedMax = false;

  BrandRecommendationHistoryCubit(this._repository)
      : super(const BrandRecommendationHistoryState());

  Future<void> getHistory({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      emit(state.copyWith(
        historyState: UiState.loading,
        history: [],
      ));
    } else {
      if (_hasReachedMax || state.historyState == UiState.loading) {
        return;
      }
      emit(state.copyWith(historyState: UiState.loading));
    }

    final result = await _repository.getBrandRecommendationHistory(
      page: _currentPage,
      limit: _limit,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
        historyState: UiState.failure,
      )),
      (history) {
        if (history.isEmpty) {
          _hasReachedMax = true;
          emit(state.copyWith(
            history: refresh ? [] : state.history,
            historyState: UiState.success,
          ));
        } else {
          _currentPage++;
          final updatedHistory = refresh
              ? history
              : [...state.history, ...history];
          _hasReachedMax = history.length < _limit;
          emit(state.copyWith(
            history: updatedHistory,
            historyState: UiState.success,
          ));
        }
      },
    );
  }

  Future<void> getRecommendationDetails(String brId) async {
    emit(state.copyWith(
      detailsState: UiState.loading,
      loadingDetailsId: brId,
    ));
    final result = await _repository.getBrandRecommendationDetails(brId: brId);
    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
        detailsState: UiState.failure,
        clearLoadingDetailsId: true,
      )),
      (recommendation) => emit(state.copyWith(
        recommendation: recommendation,
        detailsState: UiState.success,
        clearLoadingDetailsId: true,
      )),
    );
  }

  /// Call after navigating to results so that when user pops back, no card shows loading.
  void clearDetailsState() {
    emit(state.copyWith(
      detailsState: UiState.initial,
      recommendation: null,
      clearLoadingDetailsId: true,
    ));
  }
}

