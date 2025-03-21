part of 'favorite_cubit.dart';

class FavoriteState extends Equatable {
  final UiState blocState;
  final List<FavoriteModel> favoriteServiceList;
  final Set<String> favoriteIds;
  final String errorMessage;

  const FavoriteState({
    this.blocState = UiState.initial,
    this.favoriteServiceList = const [],
    this.favoriteIds = const {},
    this.errorMessage = '',
  });

  FavoriteState copyWith({
    UiState? blocState,
    List<FavoriteModel>? favoriteServiceList,
    Set<String>? favoriteIds,
    String? errorMessage,
  }) {
    return FavoriteState(
      blocState: blocState ?? this.blocState,
      favoriteServiceList: favoriteServiceList ?? this.favoriteServiceList,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        blocState,
        favoriteServiceList,
        favoriteIds,
        errorMessage,
      ];
}
