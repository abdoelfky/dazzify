part of 'services_bloc.dart';

class ServicesState extends Equatable {
  // States
  final UiState popularServicesState;
  final UiState topRatedServicesState;

  // Data
  final List<ServiceDetailsModel> popularServices;
  final List<ServiceDetailsModel> topRatedServices;

  final String errorMessage;
  final bool hasPopularServicesReachedMax;
  final bool hasTopRatedServicesReachedMax;

  const ServicesState({
    this.popularServicesState = UiState.initial,
    this.topRatedServicesState = UiState.initial,
    this.errorMessage = '',
    this.popularServices = const [],
    this.topRatedServices = const [],
    this.hasPopularServicesReachedMax = false,
    this.hasTopRatedServicesReachedMax = false,
  });

  ServicesState copyWith({
    UiState? popularServicesState,
    UiState? topRatedServicesState,
    List<ServiceDetailsModel>? popularServices,
    List<ServiceDetailsModel>? topRatedServices,
    String? errorMessage,
    bool? hasPopularServicesReachedMax,
    bool? hasTopRatedServicesReachedMax,
  }) {
    return ServicesState(
      popularServicesState: popularServicesState ?? this.popularServicesState,
      topRatedServicesState:
          topRatedServicesState ?? this.topRatedServicesState,
      popularServices: popularServices ?? this.popularServices,
      topRatedServices: topRatedServices ?? this.topRatedServices,
      errorMessage: errorMessage ?? this.errorMessage,
      hasPopularServicesReachedMax:
          hasPopularServicesReachedMax ?? this.hasPopularServicesReachedMax,
      hasTopRatedServicesReachedMax:
          hasTopRatedServicesReachedMax ?? this.hasTopRatedServicesReachedMax,
    );
  }

  @override
  List<Object> get props => [
        popularServicesState,
        topRatedServicesState,
        popularServices,
        topRatedServices,
        errorMessage,
        hasPopularServicesReachedMax,
        hasTopRatedServicesReachedMax,
      ];
}
