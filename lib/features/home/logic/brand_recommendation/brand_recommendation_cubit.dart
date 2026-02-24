import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/models/brand_recommendation_model.dart';
import 'package:dazzify/features/home/data/models/category_model.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/generate_brand_recommendation_request.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'brand_recommendation_state.dart';

@injectable
class BrandRecommendationCubit extends Cubit<BrandRecommendationState> {
  final HomeRepository _repository;

  BrandRecommendationCubit(this._repository)
      : super(const BrandRecommendationState());

  Future<void> generateRecommendation({
    required int totalBudget,
    required String date,
    required List<CategoryWeight> categories,
  }) async {
    emit(state.copyWith(blocState: UiState.loading));

    final request = GenerateBrandRecommendationRequest(
      totalBudget: totalBudget,
      date: date,
      categories: categories,
    );

    final result = await _repository.generateBrandRecommendation(
      request: request,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (recommendation) => emit(
        state.copyWith(
          blocState: UiState.success,
          recommendation: recommendation,
        ),
      ),
    );
  }

  void reset() {
    emit(const BrandRecommendationState());
  }
}

