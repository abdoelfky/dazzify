import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/shared/widgets/dazzify_rounded_picture.dart';
import 'package:dazzify/features/shared/widgets/glass_icon_button.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';

class HomeAppBarComponent extends StatelessWidget {
  const HomeAppBarComponent({super.key});

  AppEventsLogger get _logger => getIt<AppEventsLogger>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(40),
          ).r,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.05),
          //     blurRadius: 10,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ).r,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile picture and welcome message
                Expanded(
                  child: Row(
                    children: [
                      BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: 55.r,
                            height: 55.r,
                            child: DazzifyRoundedPicture(
                              imageUrl: state.userModel.picture ?? "",
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DText(
                                  context.tr.welcome,
                                  style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                                DText(
                                  state.userModel.fullName,
                                  style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: context.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Heart and bell icons
                Row(
                  children: [
                    GlassIconButton(
                      icon: SolarIconsOutline.heart,
                      onPressed: () {
                        _logger.logEvent(
                          event: AppEvents.homeClickFavourites,
                        );
                        if (AuthLocalDatasourceImpl().checkGuestMode()) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            builder: (context) {
                              return GuestModeBottomSheet();
                            },
                          );
                        } else {
                          context.navigateTo(const MyFavoriteRoute());
                        }
                      },
                    ),
                    SizedBox(width: 8.w),
                    GlassIconButton(
                      icon: SolarIconsOutline.bell,
                      onPressed: () {
                        _logger.logEvent(
                          event: AppEvents.homeClickNotifications,
                        );
                        if (AuthLocalDatasourceImpl().checkGuestMode()) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            builder: (context) {
                              return GuestModeBottomSheet();
                            },
                          );
                        } else {
                          context.pushRoute(const NotificationsRoute());
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

