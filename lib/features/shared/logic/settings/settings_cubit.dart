import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/shared/data/repositories/local_repository/local_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'settings_state.dart';

@singleton
class SettingsCubit extends Cubit<SettingsState> {
  final LocalRepository _localRepository;
  late String currentLanguageCode;
  late bool isDarkTheme;

  SettingsCubit(this._localRepository) : super(const SettingsState()) {
    currentLanguageCode = AppConstants.enCode;
  }

  void checkAppTheme() {
    try {
      isDarkTheme = _localRepository.checkAppTheme();
      emit(
        state.copyWith(
          isDarkTheme: isDarkTheme,
          themeState: UiState.success,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          themeState: UiState.failure,
          settingsFailureMessage: 'There was an error',
        ),
      );
    }
  }

  Future<void> changeAppTheme() async {
    try {
      isDarkTheme = await _localRepository.changeAppTheme(
        isDarkTheme: !state.isDarkTheme,
      );
      emit(
        state.copyWith(
          isDarkTheme: isDarkTheme,
          themeState: UiState.success,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          themeState: UiState.failure,
          settingsFailureMessage: 'There was an error',
        ),
      );
    }
  }

  void checkAppLanguage() {
    try {
      currentLanguageCode = _localRepository.checkAppLocale();
      emit(
        state.copyWith(
          currentLanguageCode: currentLanguageCode,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          languageState: UiState.failure,
          settingsFailureMessage: 'There was an error',
        ),
      );
    }
  }

  Future<void> changeAppLanguage({required String languageCode}) async {
    try {
      emit(state.copyWith(languageState: UiState.loading));
      currentLanguageCode = await _localRepository.changeAppLocale(
        languageCode: languageCode,
      );
      emit(
        state.copyWith(
            currentLanguageCode: currentLanguageCode,
            languageState: UiState.success),
      );
    } on Exception {
      emit(
        state.copyWith(
          languageState: UiState.failure,
          settingsFailureMessage: 'There was an error',
        ),
      );
    }
  }
}
