import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
import 'package:dazzify/features/user/data/requests/update_profile_location_request.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:injectable/injectable.dart';

part 'location_state.dart';

@injectable
class LocationCubit extends Cubit<LocationState> {
  final UserRepository _profileRepository;

  LocationCubit(
    this._profileRepository,
  ) : super(const LocationState());

  Future<void> updateProfileLocation({
    required double longitude,
    required double latitude,
  }) async {
    emit(state.copyWith(blocState: UiState.loading));
    final result = await _profileRepository.updateProfileLocation(
      request: UpdateProfileLocationRequest(
        longitude: longitude,
        latitude: latitude,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (userModel) {
        emit(
          state.copyWith(
            blocState: UiState.success,
          ),
        );
      },
    );
  }

  void showButton() {
    emit(state.copyWith(showButton: true));
  }

  void addMarker(double latitude, double longitude) {
    Marker newMarker = Marker(
      markerId: const MarkerId('1'),
      position: LatLng(latitude, longitude),
    );

    emit(state.copyWith(markers: Set.from(state.markers)..add(newMarker)));
  }
}
