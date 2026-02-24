part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

final class GetMediaItemsEvent extends SearchEvent {}

final class GetSearchResultsEvent extends SearchEvent {
  final String? keyWord;
  final String? searchType;

  const GetSearchResultsEvent({this.keyWord, this.searchType});

  @override
  List<Object?> get props => [keyWord, searchType];
}

final class SwitchScreenViewEvent extends SearchEvent {
  final bool showMedia;

  const SwitchScreenViewEvent({required this.showMedia});

  @override
  List<Object?> get props => [showMedia];
}

final class RefreshEvent extends SearchEvent {
  const RefreshEvent();
}

final class GetMoreBrandsEvent extends SearchEvent {
  final String? keyWord;

  const GetMoreBrandsEvent({this.keyWord});

  @override
  List<Object?> get props => [keyWord];
}

final class GetMoreServicesEvent extends SearchEvent {
  final String? keyWord;

  const GetMoreServicesEvent({this.keyWord});

  @override
  List<Object?> get props => [keyWord];
}

/// Emits loading state immediately (no debounce) so UI shows skeleton
/// before the debounced search runs. Use when switching brand/service or on search.
/// [searchType] when set clears only that list so the other tab keeps its results.
final class EmitSearchLoadingEvent extends SearchEvent {
  final String? searchType;

  const EmitSearchLoadingEvent({this.searchType});

  @override
  List<Object?> get props => [searchType];
}

/// Clears search results and shows media view immediately (no debounce).
final class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}
