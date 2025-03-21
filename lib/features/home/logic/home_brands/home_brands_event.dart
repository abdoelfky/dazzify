part of 'home_brands_bloc.dart';

sealed class HomeBrandsEvent extends Equatable {
  const HomeBrandsEvent();

  @override
  List<Object> get props => [];
}

class GetPopularBrandsEvent extends HomeBrandsEvent {
  const GetPopularBrandsEvent();

  @override
  List<Object> get props => [];
}

class GetTopRatedBrandsEvent extends HomeBrandsEvent {
  const GetTopRatedBrandsEvent();

  @override
  List<Object> get props => [];
}
