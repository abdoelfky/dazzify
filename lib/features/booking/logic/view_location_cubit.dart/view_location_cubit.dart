import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart';
import 'package:dazzify/features/booking/data/requests/get_location_name_request.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

part 'view_location_state.dart';

@Injectable()
class ViewLocationCubit extends Cubit<ViewLocationState> {
  final BookingRepository _repository;

  ViewLocationCubit(
    this._repository,
  ) : super(const ViewLocationState());

  Future<void> getLocationName({
    required double latitude,
    required double longitude,
  }) async {
    emit(state.copyWith(blocState: UiState.loading));

    final result = await _repository.getLocationName(
      request: GetLocationNameRequest(
        latitude: latitude,
        longitude: longitude,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          blocState: UiState.failure,
        ),
      ),
      (locationName) => emit(
        state.copyWith(
          blocState: UiState.success,
          locationName: locationName,
        ),
      ),
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
