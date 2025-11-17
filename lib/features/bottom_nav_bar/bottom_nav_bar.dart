import 'dart:ui';
import 'package:auto_route/auto_route.dart';
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
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
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
  
  // Swipe back animation controller
  late AnimationController _swipeController;
  double _dragDistance = 0.0;
  bool _isDragging = false;

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
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
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
    _swipeController.dispose();
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
      child: AutoTabsBuilder(
        routes: routes,
        builder: (context, child, tabsRouter) {
          return BackButtonListener(
            onBackButtonPressed: () async {
              // If not on first tab, go to previous tab
              if (tabsRouter.activeIndex > 0) {
                tabsRouter.setActiveIndex(tabsRouter.activeIndex - 1);
                return true; // Prevent default back behavior
              }
              return false; // Allow default back behavior (exit app)
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) => _handleDragStart(details, tabsRouter),
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: (details) => _handleDragEnd(details, tabsRouter),
              child: AnimatedBuilder(
                animation: _swipeController,
                builder: (context, scaffoldChild) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final textDirection = Directionality.of(context);
                  
                  // For RTL, slide to the left (negative). For LTR, slide to the right (positive)
                  final offset = textDirection == TextDirection.rtl
                      ? -(_swipeController.value * screenWidth)
                      : _swipeController.value * screenWidth;
                  
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: scaffoldChild,
                  );
                },
                child: Scaffold(
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
                  ),
              ),
            ),
          );
        },
      ),
    );
  }

  handleNavbarItemTap({required int value, required TabsRouter tabsRouter}) {
    if (value == routes.length-1) {
      tabsRouter.current.router.navigate(routes[value]);
    } else if (tabsRouter.activeIndex == value) {
      tabsRouter.current.router.navigate(routes[value]);
    } else {
      tabsRouter.setActiveIndex(value);
    }
  }

  void _handleDragStart(DragStartDetails details, TabsRouter tabsRouter) {
    if (tabsRouter.activeIndex == 0) return; // Can't go back from first tab
    
    final screenWidth = MediaQuery.of(context).size.width;
    final textDirection = Directionality.of(context);
    final startPosition = details.globalPosition.dx;
    
    // For RTL, swipe from right edge. For LTR, swipe from left edge
    final isValidSwipePosition = textDirection == TextDirection.rtl
        ? startPosition > screenWidth - 80  // Right edge for RTL
        : startPosition < 80;                // Left edge for LTR
    
    if (isValidSwipePosition) {
      setState(() {
        _isDragging = true;
        _dragDistance = 0.0;
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final textDirection = Directionality.of(context);
    final delta = details.primaryDelta ?? 0;
    
    setState(() {
      // For RTL, drag left (negative delta) means going back
      // For LTR, drag right (positive delta) means going back
      final dragValue = textDirection == TextDirection.rtl ? -delta : delta;
      _dragDistance += dragValue;
      
      // Clamp drag distance to prevent negative values
      _dragDistance = _dragDistance.clamp(0.0, double.infinity);
      
      // Update animation controller based on drag progress
      final screenWidth = MediaQuery.of(context).size.width;
      _swipeController.value = (_dragDistance / screenWidth).clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd(DragEndDetails details, TabsRouter tabsRouter) {
    if (!_isDragging) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.25; // 25% of screen width
    final velocity = details.primaryVelocity ?? 0;
    final textDirection = Directionality.of(context);
    
    // For RTL, negative velocity means swiping left (back gesture)
    // For LTR, positive velocity means swiping right (back gesture)
    final effectiveVelocity = textDirection == TextDirection.rtl ? -velocity : velocity;

    // Navigate back if dragged beyond threshold or if velocity is high enough
    if (_dragDistance > threshold || effectiveVelocity > 500) {
      // Animate to completion and then navigate back
      _swipeController.animateTo(1.0, curve: Curves.easeOut).then((_) {
        if (mounted && tabsRouter.activeIndex > 0) {
          tabsRouter.setActiveIndex(tabsRouter.activeIndex - 1);
        }
        _resetDrag();
      });
    } else {
      _resetDrag();
    }
  }

  void _resetDrag() {
    _swipeController.animateTo(0.0, curve: Curves.easeOut).then((_) {
      if (mounted) {
        setState(() {
          _dragDistance = 0.0;
          _isDragging = false;
        });
      }
    });
  }
}
