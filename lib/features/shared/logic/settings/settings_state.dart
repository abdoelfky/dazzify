part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isDarkTheme;
  final UiState themeState;
  final UiState languageState;
  final String settingsFailureMessage;
  final String currentLanguageCode;

  const SettingsState({
    this.isDarkTheme = false,
    this.themeState = UiState.loading,
    this.languageState = UiState.loading,
    this.settingsFailureMessage = '',
    this.currentLanguageCode = AppConstants.enCode,
  });

  @override
  List<Object> get props => [
        isDarkTheme,
        themeState,
        languageState,
        settingsFailureMessage,
        currentLanguageCode,
      ];

  SettingsState copyWith({
    bool? isDarkTheme,
    UiState? themeState,
    UiState? languageState,
    String? settingsFailureMessage,
    String? currentLanguageCode,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      themeState: themeState ?? this.themeState,
      languageState: languageState ?? this.languageState,
      settingsFailureMessage:
          settingsFailureMessage ?? this.settingsFailureMessage,
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
    );
  }
}
