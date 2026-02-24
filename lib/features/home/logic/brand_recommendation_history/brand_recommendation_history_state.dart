part of 'brand_recommendation_history_cubit.dart';

class BrandRecommendationHistoryState extends Equatable {
  final UiState historyState;
  final UiState detailsState;
  final String errorMessage;
  final List<BrandRecommendationHistoryModel> history;
  final BrandRecommendationModel? recommendation;
  /// ID of the history item whose details are currently loading (for per-card loading).
  final String? loadingDetailsId;

  const BrandRecommendationHistoryState({
    this.historyState = UiState.initial,
    this.detailsState = UiState.initial,
    this.errorMessage = '',
    this.history = const [],
    this.recommendation,
    this.loadingDetailsId,
  });

  BrandRecommendationHistoryState copyWith({
    UiState? historyState,
    UiState? detailsState,
    String? errorMessage,
    List<BrandRecommendationHistoryModel>? history,
    BrandRecommendationModel? recommendation,
    String? loadingDetailsId,
    bool clearLoadingDetailsId = false,
  }) {
    return BrandRecommendationHistoryState(
      historyState: historyState ?? this.historyState,
      detailsState: detailsState ?? this.detailsState,
      errorMessage: errorMessage ?? this.errorMessage,
      history: history ?? this.history,
      recommendation: recommendation ?? this.recommendation,
      loadingDetailsId: clearLoadingDetailsId ? null : (loadingDetailsId ?? this.loadingDetailsId),
    );
  }

  @override
  List<Object?> get props => [
        historyState,
        detailsState,
        errorMessage,
        history,
        recommendation,
        loadingDetailsId,
      ];
}

