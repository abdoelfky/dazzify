part of 'reels_bloc.dart';

sealed class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object?> get props => [];
}

class GetReelsEvent extends ReelsEvent {
  const GetReelsEvent();
}

class FilterReelsByCategories extends ReelsEvent {
  final String? mainCategoryId;

  const FilterReelsByCategories({this.mainCategoryId});

  @override
  List<Object?> get props => [mainCategoryId];
}

class AddViewForReelEvent extends ReelsEvent {
  final String reelId;

  const AddViewForReelEvent({required this.reelId});

  @override
  List<Object?> get props => [reelId];
}
