part of 'recommendation_details_cubit.dart';

class RecommendationDetailsState extends Equatable {
  final UiState state;
  final BrandRecommendationModel? recommendation;
  final String errorMessage;

  const RecommendationDetailsState({
    this.state = UiState.initial,
    this.recommendation,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [state, recommendation, errorMessage];
}
