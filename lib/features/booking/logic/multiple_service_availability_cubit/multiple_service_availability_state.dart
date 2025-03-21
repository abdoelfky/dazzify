part of 'multiple_service_availability_cubit.dart';

class MultipleServiceAvailabilityState extends Equatable {
  final UiState blocState;
  final Map<String, List<VendorSessionModel>> allVendorSessions;
  final Map<AvailabilityDayTime, List<VendorSessionModel>> availableSessions;
  final String errorMessage;
  final AvailabilityDayTime selectedDayTime;
  final int selectedSessionIndex;
  final String selectedDate;
  final bool isSessionConfirmed;
  final VendorSessionModel selectedSession;
  final bool isAnySessionSelected;

  const MultipleServiceAvailabilityState({
    this.blocState = UiState.initial,
    this.allVendorSessions = const {},
    this.availableSessions = const {
      AvailabilityDayTime.am: [],
      AvailabilityDayTime.pm: []
    },
    this.errorMessage = '',
    this.selectedDayTime = AvailabilityDayTime.am,
    this.selectedSessionIndex = 0,
    this.selectedDate = '',
    this.isSessionConfirmed = false,
    this.selectedSession = const VendorSessionModel.empty(),
    this.isAnySessionSelected = false,
  });

  MultipleServiceAvailabilityState copyWith({
    UiState? blocState,
    Map<String, List<VendorSessionModel>>? allVendorSessions,
    Map<AvailabilityDayTime, List<VendorSessionModel>>? availableSessions,
    String? errorMessage,
    AvailabilityDayTime? selectedDayTime,
    int? selectedSessionIndex,
    String? selectedDate,
    bool? isSessionConfirmed,
    VendorSessionModel? selectedSession,
    bool? isAnySessionSelected,
  }) {
    return MultipleServiceAvailabilityState(
      blocState: blocState ?? this.blocState,
      allVendorSessions: allVendorSessions ?? this.allVendorSessions,
      availableSessions: availableSessions ?? this.availableSessions,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedDayTime: selectedDayTime ?? this.selectedDayTime,
      selectedSessionIndex: selectedSessionIndex ?? this.selectedSessionIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      isSessionConfirmed: isSessionConfirmed ?? this.isSessionConfirmed,
      selectedSession: selectedSession ?? this.selectedSession,
      isAnySessionSelected: isAnySessionSelected ?? this.isAnySessionSelected,
    );
  }

  @override
  List<Object?> get props => [
        blocState,
        allVendorSessions,
        availableSessions,
        errorMessage,
        selectedDayTime,
        selectedSessionIndex,
        selectedDate,
        isSessionConfirmed,
        selectedSession,
        isAnySessionSelected,
      ];
}
