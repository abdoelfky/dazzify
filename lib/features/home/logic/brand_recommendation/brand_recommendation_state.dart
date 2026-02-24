part of 'brand_recommendation_cubit.dart';

class BrandRecommendationState extends Equatable {
  final UiState blocState;
  final String errorMessage;
  final BrandRecommendationModel? recommendation;

  const BrandRecommendationState({
    this.blocState = UiState.initial,
    this.errorMessage = '',
    this.recommendation,
  });

  BrandRecommendationState copyWith({
    UiState? blocState,
    String? errorMessage,
    BrandRecommendationModel? recommendation,
  }) {
    return BrandRecommendationState(
      blocState: blocState ?? this.blocState,
      errorMessage: errorMessage ?? this.errorMessage,
      recommendation: recommendation ?? this.recommendation,
    );
  }

  @override
  List<Object?> get props => [
        blocState,
        errorMessage,
        recommendation,
      ];
}

