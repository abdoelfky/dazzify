part of 'services_bloc.dart';

sealed class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

class GetPopularServicesEvent extends ServicesEvent {
  const GetPopularServicesEvent();

  @override
  List<Object> get props => [];
}

class GetTopRatedServicesEvent extends ServicesEvent {
  const GetTopRatedServicesEvent();

  @override
  List<Object> get props => [];
}

class FilterTopRatedServicesByCategory extends ServicesEvent {
  final String? mainCategoryId;

  const FilterTopRatedServicesByCategory({this.mainCategoryId});

  @override
  List<Object> get props => [mainCategoryId ?? ''];
}

class FilterPopularServicesByCategory extends ServicesEvent {
  final String? mainCategoryId;

  const FilterPopularServicesByCategory({this.mainCategoryId});

  @override
  List<Object> get props => [mainCategoryId ?? ''];
}
