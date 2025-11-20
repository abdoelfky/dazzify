import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/notifications/logic/in_app_notifications/in_app_notifications_bloc.dart';
import 'package:dazzify/features/notifications/presentation/widgets/notification_item.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class NotificationsScreen extends StatefulWidget implements AutoRouteWrapper {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InAppNotificationsBloc>(),
      child: this,
    );
  }
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final ScrollController _controller;
  late final InAppNotificationsBloc inAppNotificationsBloc;

  void _onScroll() async {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      inAppNotificationsBloc.add(GetNotificationsList());
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: false,
    );
    inAppNotificationsBloc = context.read<InAppNotificationsBloc>();
    _controller.addListener(_onScroll);
    inAppNotificationsBloc.add(GetNotificationsList());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DazzifyAppBar(
              isLeading: true,
              title: context.tr.notifications,
              horizontalPadding: 16.r,
            ),
            Expanded(
              child:
                  BlocBuilder<InAppNotificationsBloc, InAppNotificationsState>(
                builder: (context, state) {
                  switch (state.notificationsState) {
                    case UiState.initial:
                    case UiState.loading:
                      return DazzifyLoadingShimmer(
                        dazzifyLoadingType: DazzifyLoadingType.listView,
                        cardWidth: context.screenWidth,
                        widgetPadding: const EdgeInsets.all(20).r,
                        cardHeight: 100.h,
                      );
                    case UiState.failure:
                      return ErrorDataWidget(
                        errorDataType: DazzifyErrorDataType.screen,
                        message: state.notificationsFailMessage,
                        onTap: () {
                          inAppNotificationsBloc.add(GetNotificationsList());
                        },
                      );
                    case UiState.success:
                      if (state.notifications.isEmpty) {
                        return CustomFadeAnimation(
                          duration: const Duration(milliseconds: 300),
                          child: EmptyDataWidget(
                            message: context.tr.noNotifications,
                          ),
                        );
                      } else {
                        return RepaintBoundary(
                          child: ListView.separated(
                            controller: _controller,
                            physics: const BouncingScrollPhysics(),
                            cacheExtent: 500.0,
                            padding: const EdgeInsets.only(
                              top: 24,
                              bottom: 30,
                              right: 16,
                              left: 16,
                            ).r,
                            itemCount: state.notifications.length + 1,
                          itemBuilder: (context, index) {
                            if (state.notifications.isNotEmpty &&
                                index >= state.notifications.length) {
                              if (state.hasNotificationsReachedMax) {
                                return const SizedBox.shrink();
                              } else {
                                return SizedBox(
                                  height: 70.h,
                                  width: context.screenWidth,
                                  child: LoadingAnimation(
                                    height: 50.h,
                                    width: 50.w,
                                  ),
                                );
                              }
                            } else {
                              return RepaintBoundary(
                                child: NotificationsItem(
                                  notification: state.notifications[index],
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 16.h,
                          ),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
