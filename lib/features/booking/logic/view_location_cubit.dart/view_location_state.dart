part of 'view_location_cubit.dart';

class ViewLocationState extends Equatable {
  final UiState blocState;
  final String errorMessage;
  final bool showButton;
  final Set<Marker> markers;
  final String locationName;

  const ViewLocationState({
    this.blocState = UiState.initial,
    this.errorMessage = '',
    this.showButton = false,
    this.markers = const {},
    this.locationName = '',
  });

  ViewLocationState copyWith({
    UiState? blocState,
    String? errorMessage,
    bool? showButton,
    Set<Marker>? markers,
    String? locationName,
  }) {
    return ViewLocationState(
      blocState: blocState ?? this.blocState,
      errorMessage: errorMessage ?? this.errorMessage,
      showButton: showButton ?? this.showButton,
      markers: markers ?? this.markers,
      locationName: locationName ?? this.locationName,
    );
  }

  @override
  List<Object> get props => [
        blocState,
        errorMessage,
        showButton,
        markers,
        locationName,
      ];
}
