part of 'report_cubit.dart';

class ReportState extends Equatable {
  final UiState uiState;
  final String message;

  const ReportState({
    this.uiState = UiState.initial,
    this.message = "",
  });

  @override
  List<Object?> get props => [uiState, message];

  ReportState copyWith({
    UiState? uiState,
    String? message,
  }) {
    return ReportState(
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }
}
