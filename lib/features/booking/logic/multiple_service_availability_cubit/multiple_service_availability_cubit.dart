import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/time_manager.dart';
import 'package:dazzify/features/booking/data/models/vendor_session_model.dart';
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart';
import 'package:dazzify/features/booking/data/requests/get_brand_slots_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'multiple_service_availability_state.dart';

@Injectable()
class MultipleServiceAvailabilityCubit
    extends Cubit<MultipleServiceAvailabilityState> {
  final BookingRepository _repository;

  MultipleServiceAvailabilityCubit(this._repository)
      : super(const MultipleServiceAvailabilityState());

  Future<dynamic> _getAvailableBrandMultiServicesSlots({
    required String branchId,
    required List<String> services,
    required String month,
    required String year,
  }) async {
    Either<Failure, List<VendorSessionModel>> result =
        await _repository.getBrandMultipleServicesAvailableSlots(
      request: GetBrandSlotsRequest(
        branchId: branchId,
        services: services,
        month: int.parse(month),
        year: int.parse(year),
      ),
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(
          errorMessage: failure.message,
          blocState: UiState.failure,
        ));
      },
      (slots) {
        Map<String, List<VendorSessionModel>> selectedMonthVendorSessions = {
          '$year-$month': slots
        };

        selectedMonthVendorSessions.addAll(state.allVendorSessions);
        emit(state.copyWith(
          allVendorSessions: selectedMonthVendorSessions,
        ));
      },
    );
  }

  Future<void> getAndProcessData({
    required String branchId,
    required List<String> services,
    String? selectedTimeStamp,
  }) async {
    emit(state.copyWith(blocState: UiState.loading));

    String selectedDateTime = selectedTimeStamp == null
        ? TimeManager.extractDate(DateTime.now().toString())
        : TimeManager.extractDate(selectedTimeStamp);
    String month = TimeManager.extractMonth(selectedDateTime);
    String year = TimeManager.extractYear(selectedDateTime);
    String selectedYearMonth = TimeManager.extractYearMonth(selectedDateTime);
    String selectedDay = TimeManager.extractDay(selectedDateTime);

    if (!state.allVendorSessions.containsKey(selectedYearMonth)) {
      await _getAvailableBrandMultiServicesSlots(
        branchId: branchId,
        services: services,
        month: month,
        year: year,
      );
    }

    List<VendorSessionModel> thisMonthSessions =
        state.allVendorSessions[selectedYearMonth] ?? [];

    Map<AvailabilityDayTime, List<VendorSessionModel>> availableSessions = {
      AvailabilityDayTime.am: [],
      AvailabilityDayTime.pm: [],
    };

    for (var session in thisMonthSessions) {
      if (session.day == selectedDay) {
        availableSessions[session.dayTime]!.add(session);
      }
    }

    AvailabilityDayTime selectedDayTime = AvailabilityDayTime.am;
    VendorSessionModel selectedSession = const VendorSessionModel.empty();
    bool isAnySessionSelected = false;

    if (availableSessions[AvailabilityDayTime.am]!.isNotEmpty) {
      selectedDayTime = AvailabilityDayTime.am;
      selectedSession = availableSessions[AvailabilityDayTime.am]!.first;
      isAnySessionSelected = true;
    } else if (availableSessions[AvailabilityDayTime.pm]!.isNotEmpty) {
      selectedDayTime = AvailabilityDayTime.pm;
      selectedSession = availableSessions[AvailabilityDayTime.pm]!.first;
      isAnySessionSelected = true;
    }

    emit(state.copyWith(
      availableSessions: availableSessions,
      selectedDate: selectedDateTime,
      isAnySessionSelected: isAnySessionSelected,
      blocState: UiState.success,
      isSessionConfirmed: false,
      selectedDayTime: selectedDayTime, // Set the first available slot
      selectedSession: selectedSession,
    ));
  }

  void changeDayTime({required AvailabilityDayTime dayTime}) {
    bool isAnySessionSelected = false;
    VendorSessionModel selectedSession = const VendorSessionModel.empty();

    if (state.availableSessions[dayTime]!.isNotEmpty) {
      selectedSession = state.availableSessions[dayTime]!.first;
      isAnySessionSelected = true;
    }

    if (dayTime != state.selectedDayTime) {
      emit(state.copyWith(
        selectedDayTime: dayTime,
        selectedSessionIndex: 0,
        isAnySessionSelected: isAnySessionSelected,
        selectedSession: selectedSession,
      ));
    }
  }

  void changeSelectedDate({
    required List<String> services,
    required String branchId,
    required String newDate,
  }) {
    getAndProcessData(
      services: services,
      branchId: branchId,
      selectedTimeStamp: newDate,
    );
  }

  void changeSelectedSession({int? newSessionIndex}) {
    int selectedSessionIndex = 0;
    bool isAnySessionSelected = false;

    if (newSessionIndex != null) {
      selectedSessionIndex = newSessionIndex;
      isAnySessionSelected = true;
    } else {
      int sessionsLength =
          state.availableSessions[state.selectedDayTime]!.length;

      if (sessionsLength > 0) {
        selectedSessionIndex =
            (state.selectedSessionIndex + 1) % sessionsLength;
        isAnySessionSelected = true;
      }
    }

    emit(state.copyWith(
      selectedSessionIndex: selectedSessionIndex,
      isAnySessionSelected: isAnySessionSelected,
      selectedSession: state.availableSessions[state.selectedDayTime]!.isEmpty
          ? const VendorSessionModel.empty()
          : state
              .availableSessions[state.selectedDayTime]![selectedSessionIndex],
      isSessionConfirmed: false,
    ));
  }

  void changeSessionConfirmation({required bool value}) {
    emit(state.copyWith(isSessionConfirmed: value));
  }
}
