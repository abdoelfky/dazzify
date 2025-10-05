part of 'privacy_policy_cubit.dart';

class PrivacyPolicyState {
  final UiState loadingState;
  final List<PrivacyPolicyModel> policies;
  final String? errorMessage;

  PrivacyPolicyState({
    this.loadingState = UiState.initial,
    this.policies = const [],
    this.errorMessage,
  });

  PrivacyPolicyState copyWith({
    UiState? loadingState,
    List<PrivacyPolicyModel>? policies,
    String? errorMessage,
  }) {
    return PrivacyPolicyState(
      loadingState: loadingState ?? this.loadingState,
      policies: policies ?? this.policies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
