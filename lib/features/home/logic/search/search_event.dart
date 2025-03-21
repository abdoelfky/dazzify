part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

final class GetMediaItemsEvent extends SearchEvent {}

final class GetSearchResultsEvent extends SearchEvent {
  final String? keyWord;

  const GetSearchResultsEvent({this.keyWord});

  @override
  List<Object?> get props => [keyWord];
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
