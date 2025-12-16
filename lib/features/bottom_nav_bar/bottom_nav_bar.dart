import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/booking/logic/booking_review/booking_review_cubit.dart';
import 'package:dazzify/features/bottom_nav_bar/widgets/nav_active_profile_picture.dart';
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
    return MultiBlocListener(
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
            bottomNavigationBar: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 15,
                  sigmaY: 15,
                ),
                child: SizedBox(
                  height: 60.h,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: BottomNavigationBar(
                        currentIndex: tabsRouter.activeIndex,
                        onTap: (value) {
                          handleNavbarItemTap(
                            value: value,
                            tabsRouter: tabsRouter,
                          );
                        },
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(
                              SolarIconsOutline.home,
                              size: 26.r,
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(
                              SolarIconsOutline.videoLibrary,
                              size: 26.r,
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(
                              SolarIconsOutline.magnifier,
                              size: 26.r,
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(
                              SolarIconsOutline.chatRoundLine,
                              size: 26.r,
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: BlocBuilder<UserCubit, UserState>(
                              builder: (BuildContext context, UserState state) {
                                return SizedBox(
                                  width: 32.r,
                                  height: 32.r,
                                  child: DazzifyRoundedPicture(
                                    imageUrl: state.userModel.picture,
                                    width: 32.r,
                                    height: 32.r,
                                  ),
                                );
                              },
                            ),
                            label: '',
                            activeIcon: BlocBuilder<UserCubit, UserState>(
                              builder: (context, state) =>
                                  NavActiveProfilePicture(
                                imagePath: state.userModel.picture ?? "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
}
