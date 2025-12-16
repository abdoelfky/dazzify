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

class FilterTopRatedBrandsByCategory extends HomeBrandsEvent {
  final String? mainCategoryId;

  const FilterTopRatedBrandsByCategory({this.mainCategoryId});

  @override
  List<Object> get props => [mainCategoryId ?? ''];
}

class FilterPopularBrandsByCategory extends HomeBrandsEvent {
  final String? mainCategoryId;

  const FilterPopularBrandsByCategory({this.mainCategoryId});

  @override
  List<Object> get props => [mainCategoryId ?? ''];
}
