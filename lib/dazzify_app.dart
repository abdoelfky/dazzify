import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/app_config_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/notifications/logic/app_notifications/app_notifications_cubit.dart';
import 'package:dazzify/features/shared/logic/settings/check_for_app_update.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:dazzify/features/shared/widgets/falvor_banner.dart';
import 'package:dazzify/generated/l10n.dart';
import 'package:dazzify/route_observer.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:dazzify/settings/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/auth/logic/auth_cubit.dart';

class DazzifyApp extends StatefulWidget {
  const DazzifyApp({super.key});

  static late S tr;

  static BuildContext get mainContext =>
      getIt<AppRouter>().navigatorKey.currentContext!;

  @override
  State<DazzifyApp> createState() => _DazzifyAppState();
}

class _DazzifyAppState extends State<DazzifyApp> {
  final settingsCubit = getIt<SettingsCubit>();
  late final TokensCubit tokensCubit;

  @override
  void initState() {
    super.initState();
    tokensCubit = getIt<TokensCubit>(); // initialize once
  }

  @override
  Widget build(BuildContext context) {
    return BuildFlavorBanner(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) => getIt<AuthCubit>()..appConfig(),
          ),
          BlocProvider(
            create: (_) => tokensCubit,
          ),
          BlocProvider(
            create: (_) => settingsCubit
              ..checkAppTheme()
              ..checkAppLanguage(),
          ),
          BlocProvider(
            create: (_) => getIt<AppNotificationsCubit>(),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(
              listener: (context, authState) async{
                if (authState is GuestModeSuccessState) {
                 await checkForAppUpdate();

                  if (AppConfigManager.isAppInMaintenance) {
                    getIt<AppRouter>().replace(const MaintenanceRoute());
                  } else {
                    tokensCubit.isUserAuthenticated();
                  }
                }
              },
            ),

          ],
          child: ScreenUtilInit(
            designSize: const Size(360, 800),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.noScaling,
                      ),
                      child: child!,
                    );
                  },
                  routerConfig: getIt<AppRouter>().config(
                    navigatorObservers: () => [
                      MyRouteObserver(),
                      AutoRouteObserver(),
                    ],
                  ),
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  onGenerateTitle: (context) {
                    DazzifyApp.tr = context.tr;
                    return DazzifyApp.tr.appName;
                  },
                  locale: Locale(settingsCubit.currentLanguageCode),
                  supportedLocales: S.delegate.supportedLocales,
                  theme: state.isDarkTheme
                      ? ThemeManager.darkTheme()
                      : ThemeManager.lightTheme(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
