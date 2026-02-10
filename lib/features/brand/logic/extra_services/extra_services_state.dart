part of 'extra_services_cubit.dart';

class ExtraServicesState extends Equatable {
  final List<ServiceDetailsModel> extraServices;
  final UiState extraServicesState;
  final String errorMessage;

  const ExtraServicesState({
    this.extraServicesState = UiState.initial,
    this.extraServices = const [],
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [
        extraServicesState,
        extraServices,
        errorMessage,
      ];

  ExtraServicesState copyWith({
    List<ServiceDetailsModel>? extraServices,
    UiState? extraServicesState,
    String? errorMessage,
  }) {
    return ExtraServicesState(
      extraServices: extraServices ?? this.extraServices,
      extraServicesState: extraServicesState ?? this.extraServicesState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

