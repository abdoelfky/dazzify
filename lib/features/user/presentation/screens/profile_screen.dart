import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/dazzify_app.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/features/user/presentation/components/profile/profile_body_component.dart';
import 'package:dazzify/features/user/presentation/components/profile/profile_header_component.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final SettingsCubit settingsCubit;
  late final ValueNotifier<bool> isLoading;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    settingsCubit = context.read<SettingsCubit>();
    isLoading = ValueNotifier(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) =>
          previous.updateProfileLangState != current.updateProfileLangState,
      listener: (context, state) async {
        if (state.updateProfileLangState == UiState.loading) {
          isLoading.value = true;
        } else if (state.updateProfileLangState == UiState.success) {
          isLoading.value = false;
          await settingsCubit.changeAppLanguage(
            languageCode: state.updatedLanguageCode,
          );
          // Navigate to splash screen to refetch all data with the new language
          context.router.replaceAll([
            const UnAuthenticatedRoute(
              children: [SplashRoute()],
            ),
          ]);
        } else {
          isLoading.value = false;
          DazzifyToastBar.showError(
            message: DazzifyApp.tr.unknownError,
          );
        }
      },
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, value, child) => DazzifyOverlayLoading(
            isLoading: value,
            child: Column(
              children: [
                const ProfileHeaderComponent(),
                SizedBox(height: 30.h),
                const ProfileBodyComponent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
