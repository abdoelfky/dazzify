part of 'likes_cubit.dart';

class LikesState extends Equatable {
  final UiState idsState;
  final UiState addLikeState;
  final UiState removeLikeState;
  final Set<String> likesIds;
  final String errorMessage;

  const LikesState({
    this.idsState = UiState.initial,
    this.addLikeState = UiState.initial,
    this.removeLikeState = UiState.initial,
    this.likesIds = const {},
    this.errorMessage = "",
  });

  LikesState copyWith({
    UiState? idsState,
    UiState? addLikeState,
    UiState? removeLikeState,
    Set<String>? likesIds,
    String? errorMessage,
  }) {
    return LikesState(
      idsState: idsState ?? this.idsState,
      addLikeState: addLikeState ?? this.addLikeState,
      removeLikeState: removeLikeState ?? this.removeLikeState,
      likesIds: likesIds ?? this.likesIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        idsState,
        addLikeState,
        removeLikeState,
        likesIds,
        errorMessage,
      ];
}
