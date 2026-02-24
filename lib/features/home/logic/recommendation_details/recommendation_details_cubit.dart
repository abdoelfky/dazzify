import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/models/brand_recommendation_model.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'recommendation_details_state.dart';

@injectable
class RecommendationDetailsCubit extends Cubit<RecommendationDetailsState> {
  final HomeRepository _repository;

  RecommendationDetailsCubit(this._repository)
      : super(const RecommendationDetailsState());

  Future<void> load(String brId) async {
    emit(const RecommendationDetailsState(state: UiState.loading));
    final result = await _repository.getBrandRecommendationDetails(brId: brId);
    result.fold(
      (failure) => emit(RecommendationDetailsState(
        state: UiState.failure,
        errorMessage: failure.message,
      )),
      (recommendation) => emit(RecommendationDetailsState(
        state: UiState.success,
        recommendation: recommendation,
      )),
    );
  }
}
