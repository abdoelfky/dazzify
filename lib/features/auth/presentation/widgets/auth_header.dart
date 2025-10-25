import 'package:dazzify/core/constants/app_constants.dart' show AppConstants;
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/auth/presentation/widgets/auth_shape_clipper.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dazzify/settings/theme/colors_scheme_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class AuthHeader extends StatelessWidget {
  final bool isLogoAnimated;

  const AuthHeader({super.key, this.isLogoAnimated = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: AuthShapeClipper(),
          child: Container(
            width: context.screenWidth,
            height: 242.h,
            color: ColorsSchemeManager.light.primary,
            child: Center(
              child: isLogoAnimated
                  ? Lottie.asset(repeat: false, AssetsManager.dazzifyAuthLogo)
                  : SvgPicture.asset(AssetsManager.appLogo),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20).r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        final newLanguage = settingsState.currentLanguageCode == AppConstants.enCode
                            ? AppConstants.arCode
                            : AppConstants.enCode;
                        context.read<SettingsCubit>().changeAppLanguage(
                          languageCode: newLanguage,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ).r,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20).r,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DText(
                              settingsState.currentLanguageCode == AppConstants.enCode
                                  ? AppConstants.usFlag
                                  : AppConstants.egyptFlag,
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(width: 6.w),
                            DText(
                              settingsState.currentLanguageCode == AppConstants.enCode
                                  ? context.tr.english
                                  : context.tr.arabic,
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

      ],
    );
  }
}
