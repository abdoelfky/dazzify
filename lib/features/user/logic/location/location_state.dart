part of 'location_cubit.dart';

class LocationState extends Equatable {
  final UiState blocState;
  final String errorMessage;
  final bool showButton;
  final Set<Marker> markers;

  const LocationState({
    this.blocState = UiState.initial,
    this.errorMessage = '',
    this.showButton = false,
    this.markers = const {},
  });

  LocationState copyWith({
    UiState? blocState,
    String? errorMessage,
    bool? showButton,
    Set<Marker>? markers,
  }) {
    return LocationState(
      blocState: blocState ?? this.blocState,
      errorMessage: errorMessage ?? this.errorMessage,
      showButton: showButton ?? this.showButton,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object> get props => [
        blocState,
        errorMessage,
        showButton,
        markers,
      ];
}
