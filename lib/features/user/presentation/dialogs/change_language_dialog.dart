import 'dart:ui';

import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';

class ChangeLanguageDialog extends StatefulWidget {
  const ChangeLanguageDialog({super.key});

  @override
  State<ChangeLanguageDialog> createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  late final SettingsCubit settingsCubit;
  late final UserCubit userCubit;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    settingsCubit = context.read<SettingsCubit>();
    userCubit = context.read<UserCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) =>
          previous.updateProfileLangState != current.updateProfileLangState,
      listener: (context, state) {
        if (state.updateProfileLangState == UiState.loading) {
          // Language change is logged when user selects a language
          context.maybePop();
        }
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: CustomFadeAnimation(
              duration: const Duration(milliseconds: 500),
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(
                  vertical: 250,
                  horizontal: 0,
                ).r,
                child: Container(
                  width: context.screenWidth * 0.9,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16).r,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DText(
                        context.tr.chooseLanguage,
                        style: context.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8.h),
                      ListTile(
                        onTap: () {
                          if (state.currentLanguageCode !=
                              AppConstants.enCode) {
                            _logger.logEvent(
                                event: AppEvents.profileChangeLanguage);
                          }
                          toEnglishLanguage(state.currentLanguageCode);
                        },
                        leading: DText(
                          AppConstants.usFlag,
                          style: context.textTheme.bodyMedium,
                        ),
                        title: DText(
                          context.tr.english,
                          style: context.textTheme.bodyMedium,
                        ),
                        trailing: Radio.adaptive(
                          value: AppConstants.enCode,
                          groupValue: state.currentLanguageCode,
                          onChanged: (value) {
                            if (state.currentLanguageCode !=
                                AppConstants.enCode) {
                              _logger.logEvent(
                                  event: AppEvents.profileSubmitEditPhone);
                            }
                            toEnglishLanguage(state.currentLanguageCode);
                          },
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          if (state.currentLanguageCode !=
                              AppConstants.arCode) {
                            _logger.logEvent(
                                event: AppEvents.profileChangeLanguage);
                          }
                          toArabicLanguage(state.currentLanguageCode);
                        },
                        leading: DText(
                          AppConstants.egyptFlag,
                          style: context.textTheme.bodyMedium,
                        ),
                        title: DText(
                          context.tr.arabic,
                          style: context.textTheme.bodyMedium,
                        ),
                        trailing: Radio.adaptive(
                          value: AppConstants.arCode,
                          groupValue: state.currentLanguageCode,
                          onChanged: (value) {
                            if (state.currentLanguageCode !=
                                AppConstants.arCode) {
                              _logger.logEvent(
                                  event: AppEvents.profileChangeLanguage);
                            }
                            toArabicLanguage(state.currentLanguageCode);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void toEnglishLanguage(String currentLanguageCode) {
    if (currentLanguageCode != AppConstants.enCode) {
      userCubit.updateProfileLang(lang: AppConstants.enCode);
    }
  }

  void toArabicLanguage(String currentLanguageCode) {
    if (currentLanguageCode != AppConstants.arCode) {
      userCubit.updateProfileLang(lang: AppConstants.arCode);
    }
  }
}
