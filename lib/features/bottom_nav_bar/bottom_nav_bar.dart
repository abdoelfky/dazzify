import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/booking/logic/booking_review/booking_review_cubit.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/notifications/logic/app_notifications/app_notifications_cubit.dart';
import 'package:dazzify/features/payment/logic/transactions/transaction_bloc.dart';
import 'package:dazzify/features/shared/helper/deep_linking_helper.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dazzify/features/shared/logic/socket/socket_cubit.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_rounded_picture.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage(name: 'BottomNavBarRoute')
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with WidgetsBindingObserver {
  late DateTime timeNow;
  late AppNotificationsCubit notificationsCubit;
  late TokensCubit tokensCubit;
  late SettingsCubit settingsCubit;
  late UserCubit userCubit;
  late TransactionBloc transactionBloc;
  late SocketCubit socketCubit;
  late BookingReviewCubit bookingReviewCubit;
  final List<PageRouteInfo<dynamic>> routes = [
    const HomeRoute(),
    const ReelsRoute(),
    const SearchRoute(),
    const ConversationsRoute(),
    const ProfileRoute(),
  ];
  late BookingCubit bookingCubit;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint(state.toString());
    if (state == AppLifecycleState.resumed) {
      await notificationsCubit.checkForNotificationsPermission();
    }
    if (state == AppLifecycleState.detached) {
      socketCubit.disconnectWebSocket();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    notificationsCubit = context.read<AppNotificationsCubit>();
    bookingCubit = context.read<BookingCubit>();
    tokensCubit = context.read<TokensCubit>();
    settingsCubit = context.read<SettingsCubit>();
    userCubit = context.read<UserCubit>();
    transactionBloc = context.read<TransactionBloc>();
    socketCubit = context.read<SocketCubit>();
    bookingReviewCubit = context.read<BookingReviewCubit>();
    notificationsCubit.getNotificationsState();

    // Only fetch missed booking reviews if not in guest mode
    if (!AuthLocalDatasourceImpl().checkGuestMode()) {
      socketCubit.connectToWebSocket();
      bookingReviewCubit.getMissedBookingReview();
    }

    DeepLinkingHelper.init();
    // NotificationsService.onClickNotification.stream.listen((event) {
    //   _handleNotificationClick(event);
    // });

    super.initState();
  }

  @override
  void dispose() {
    mainCategories.clear();
    socketCubit.disconnectWebSocket();
    super.dispose();
  }

  //
  // void _handleNotificationClick(NotificationResponse event) {
  //   final notificationType = getNotificationType(event.payload);
  //
  //   switch (notificationType) {
  //     case NotificationTypeEnum.payment:
  //       context.router.navigate(
  //         const ProfileTabRoute(
  //           children: [
  //             ProfileRoute(),
  //             PaymentRoutes(children: [TransactionRoute()]),
  //           ],
  //         ),
  //       );
  //       break;
  //     case NotificationTypeEnum.bookingStatus:
  //       context.router.navigate(
  //         const ProfileTabRoute(
  //           children: [ProfileRoute(), BookingsHistoryRoute()],
  //         ),
  //       );
  //       break;
  //     default:
  //       context.router.navigate(const NotificationsRoute());
  //   }
  // }

  @override
  Widget build(context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: MultiBlocListener(
        listeners: [
          BlocListener<TokensCubit, TokensState>(
            listener: (context, state) {},
          ),
          BlocListener<UserCubit, UserState>(
            listenWhen: (previous, current) =>
                previous.userState != current.userState,
            listener: (context, state) {
              if (state.userState == UiState.success) {
                if (state.userModel.deletedAt.isNotEmpty) {
                  tokensCubit.emitSessionExpired();
                } else if (state.userModel.languagePreference !=
                    settingsCubit.currentLanguageCode) {
                  userCubit.updateProfileLang(
                    lang: settingsCubit.currentLanguageCode,
                  );
                }
              }
            },
          ),
        ],
        child: AutoTabsRouter(
          routes: routes,
          builder: (context, child) {
            final tabsRouter = context.tabsRouter;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody: true,
              body: child,
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 10.h,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY: 20,
                    ),
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _getActiveColor(context, tabsRouter.activeIndex)
                                .withValues(alpha: 0.12),
                            _getActiveColor(context, tabsRouter.activeIndex)
                                .withValues(alpha: 0.12),
                            _getActiveColor(context, tabsRouter.activeIndex)
                                .withValues(alpha: 0.12),
                          ],
                          stops: const [0.0, 0.3, 1.0],
                        ),
                        border: Border.all(
                          color: context.isDarkTheme
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Home Icon
                          _buildNavItem(
                            context: context,
                            isActive: tabsRouter.activeIndex == 0,
                            icon: SolarIconsOutline.home,
                            onTap: () {
                              handleNavbarItemTap(
                                value: 0,
                                tabsRouter: tabsRouter,
                              );
                            },
                          ),
                          // Video Library Icon
                          _buildNavItem(
                            context: context,
                            isActive: tabsRouter.activeIndex == 1,
                            icon: SolarIconsOutline.videoLibrary,
                            onTap: () {
                              handleNavbarItemTap(
                                value: 1,
                                tabsRouter: tabsRouter,
                              );
                            },
                          ),
                          // Search Icon
                          _buildNavItem(
                            context: context,
                            isActive: tabsRouter.activeIndex == 2,
                            icon: SolarIconsOutline.magnifier,
                            onTap: () {
                              handleNavbarItemTap(
                                value: 2,
                                tabsRouter: tabsRouter,
                              );
                            },
                          ),
                          // Chat Icon
                          _buildNavItem(
                            context: context,
                            isActive: tabsRouter.activeIndex == 3,
                            icon: SolarIconsOutline.chatRoundLine,
                            onTap: () {
                              handleNavbarItemTap(
                                value: 3,
                                tabsRouter: tabsRouter,
                              );
                            },
                          ),
                          // Profile Icon
                          _buildProfileNavItem(
                            context: context,
                            isActive: tabsRouter.activeIndex == 4,
                            onTap: () {
                              handleNavbarItemTap(
                                value: 4,
                                tabsRouter: tabsRouter,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  handleNavbarItemTap({required int value, required TabsRouter tabsRouter}) {
    // Log nav bar click
    switch (value) {
      case 0:
        _logger.logEvent(event: AppEvents.navClickHome);
        break;
      case 1:
        _logger.logEvent(event: AppEvents.navClickReels);
        break;
      case 2:
        _logger.logEvent(event: AppEvents.navClickSearch);
        break;
      case 3:
        _logger.logEvent(event: AppEvents.navClickChat);
        break;
      case 4:
        _logger.logEvent(event: AppEvents.navClickProfile);
        break;
    }

    if (value == routes.length - 1) {
      tabsRouter.current.router.navigate(routes[value]);
    } else if (tabsRouter.activeIndex == value) {
      tabsRouter.current.router.navigate(routes[value]);
    } else {
      tabsRouter.setActiveIndex(value);
    }
  }

  Widget _buildNavItem({
    required BuildContext context,
    required bool isActive,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? context.colorScheme.primary : Colors.transparent,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 12.r,
                    spreadRadius: 2.r,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 26.r,
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildProfileNavItem({
    required BuildContext context,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: BlocBuilder<UserCubit, UserState>(
        builder: (BuildContext context, UserState state) {
          return Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isActive
                  ? Border.all(
                      color: context.colorScheme.primary,
                      width: 2.r,
                    )
                  : null,
            ),
            child: DazzifyRoundedPicture(
              imageUrl: state.userModel.picture,
              width: 32.r,
              height: 32.r,
            ),
          );
        },
      ),
    );
  }

  Color _getActiveColor(BuildContext context, int activeIndex) {
    // Return primary color (green) for all active icons
    return context.colorScheme.primary;
  }
}
