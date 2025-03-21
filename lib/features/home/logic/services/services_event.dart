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
