part of 'reels_bloc.dart';

class ReelsState extends Equatable {
  final UiState reelsState;
  final UiState addViewState;
  final List<MediaModel> reels;
  final bool hasReelsReachedMax;
  final String errorMessage;

  const ReelsState({
    this.reelsState = UiState.initial,
    this.addViewState = UiState.initial,
    this.reels = const [],
    this.hasReelsReachedMax = false,
    this.errorMessage = "",
  });

  @override
  List<Object> get props => [
        reelsState,
        addViewState,
        reels,
        hasReelsReachedMax,
        errorMessage,
      ];

  ReelsState copyWith({
    UiState? reelsState,
    UiState? addViewState,
    List<MediaModel>? reels,
    bool? hasReelsReachedMax,
    String? errorMessage,
  }) {
    return ReelsState(
      reelsState: reelsState ?? this.reelsState,
      addViewState: addViewState ?? this.addViewState,
      reels: reels ?? this.reels,
      hasReelsReachedMax: hasReelsReachedMax ?? this.hasReelsReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
