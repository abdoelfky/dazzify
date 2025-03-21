part of 'service_details_bloc.dart';

class ServiceDetailsEvent extends Equatable {
  const ServiceDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetBrandBranchesEvent extends ServiceDetailsEvent {
  final String brandId;

  const GetBrandBranchesEvent({required this.brandId});

  @override
  List<Object> get props => [brandId];
}

class GetServiceDetailsEvent extends ServiceDetailsEvent {
  final String serviceId;

  const GetServiceDetailsEvent({required this.serviceId});

  @override
  List<Object> get props => [serviceId];
}

class AddServiceEvent extends ServiceDetailsEvent {
  final ServiceDetailsModel service;

  const AddServiceEvent({required this.service});

  @override
  List<Object> get props => [service];
}

class GetServiceReviewsEvent extends ServiceDetailsEvent {
  final String serviceId;

  const GetServiceReviewsEvent({required this.serviceId});

  @override
  List<Object> get props => [serviceId];
}

class GetMoreLikeThisEvent extends ServiceDetailsEvent {
  final String serviceId;

  const GetMoreLikeThisEvent({required this.serviceId});

  @override
  List<Object> get props => [serviceId];
}
