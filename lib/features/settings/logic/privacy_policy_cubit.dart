import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/settings/data/models/privacy_policy_model.dart';
import 'package:dazzify/features/settings/data/repositories/settings_repository.dart';
import 'package:injectable/injectable.dart';

part 'privacy_policy_state.dart';

@injectable
class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  final SettingsRepository settingsRepository;

  PrivacyPolicyCubit({required this.settingsRepository})
      : super(PrivacyPolicyState());

  Future<void> getPrivacyPolicies() async {
    emit(state.copyWith(loadingState: UiState.loading));

    final result = await settingsRepository.getPrivacyPolicies();

    result.fold(
      (error) {
        emit(state.copyWith(
          loadingState: UiState.failure,
          errorMessage: error.toString(),
        ));
      },
      (response) {
        emit(state.copyWith(
          loadingState: UiState.success,
          policies: response.data.policies,
        ));
      },
    );
  }
}
