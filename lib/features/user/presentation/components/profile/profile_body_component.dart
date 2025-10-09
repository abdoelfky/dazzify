import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/notifications/logic/app_notifications/app_notifications_cubit.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_dialog.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/permission_dialog.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/features/user/presentation/bottom_sheets/update_phone_number_sheet.dart';
import 'package:dazzify/features/user/presentation/dialogs/change_language_dialog.dart';
import 'package:dazzify/features/user/presentation/widgets/icon_switcher.dart';
import 'package:dazzify/features/user/presentation/widgets/profile_custom_list_tile.dart';
import 'package:dazzify/features/user/presentation/widgets/profile_section.dart';

class ProfileBodyComponent extends StatefulWidget {
  const ProfileBodyComponent({super.key});

  @override
  State<ProfileBodyComponent> createState() => _ProfileBodyComponentState();
}

class _ProfileBodyComponentState extends State<ProfileBodyComponent> {
  late UserCubit _userCubit;
  late TokensCubit _tokensCubit;
  late AppNotificationsCubit _notificationsCubit;

  @override
  void initState() {
    _userCubit = context.read<UserCubit>();
    _tokensCubit = context.read<TokensCubit>();
    _notificationsCubit = context.read<AppNotificationsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 70,
        ).r,
        children: [
          ProfileSection(
            sectionTitle: context.tr.userSettings,
            margin: EdgeInsets.zero,
            children: Column(
              children: [
                ProfileCustomListTile(
                  iconData: SolarIconsOutline.phone,
                  title: context.tr.phoneNumber,
                  onTap: () {
                    if (AuthLocalDatasourceImpl().checkGuestMode()) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) {
                          return GuestModeBottomSheet();
                        },
                      );
                    } else {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        routeSettings: const RouteSettings(
                          name: "UpdatePhoneSheetRoute",
                        ),
                        builder: (context) {
                          return BlocProvider.value(
                            value: _userCubit,
                            child: const UpdatePhoneNumberSheet(),
                          );
                        },
                      );
                    }
                  },
                ),
                ProfileCustomListTile(
                  iconData: SolarIconsOutline.heart,
                  title: context.tr.myFavorite,
                  onTap: () {
                    context.pushRoute(const MyFavoriteRoute());
                  },
                ),
              ],
            ),
          ),
          ProfileSection(
            sectionTitle: context.tr.servicesSettings,
            children: Column(
              children: [
                // ProfileCustomListTile(
                //   iconData: SolarIconsOutline.mapPoint,
                //   title: context.localizedText.location,
                //   onTap: () {
                //     context.pushRoute(UserLocationRoute(
                //       locationModel:
                //           _userCubit.state.userModel.profile.location,
                //       userCubit: _userCubit,
                //     ));
                //   },
                // ),
                ProfileCustomListTile(
                  iconData: SolarIconsOutline.history,
                  title: "  ${context.tr.bookingsHistory}",
                  onTap: () {
                    if (AuthLocalDatasourceImpl().checkGuestMode()) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) {
                          return GuestModeBottomSheet();
                        },
                      );
                    } else {
                      context.pushRoute(const BookingsHistoryRoute());
                    }
                  },
                ),
                ProfileCustomListTile(
                  iconData: SolarIconsOutline.chatSquare,
                  title: context.tr.issue,
                  onTap: () {
                    if (AuthLocalDatasourceImpl().checkGuestMode()) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) {
                          return GuestModeBottomSheet();
                        },
                      );
                    } else {
                      context.pushRoute(const IssueRoute());
                    }
                  },
                ),
                ProfileCustomListTile(
                  iconData: SolarIconsOutline.wallet,
                  title: context.tr.payment,
                  onTap: () {
                    if (AuthLocalDatasourceImpl().checkGuestMode()) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) {
                          return GuestModeBottomSheet();
                        },
                      );
                    } else {
                      context.pushRoute(const TransactionRoute());
                    }
                  },
                ),
              ],
            ),
          ),
          ProfileSection(
            sectionTitle: context.tr.appSettings,
            children: Column(
              children: [
                ProfileCustomListTile(
                  iconData: Icons.language_outlined,
                  title: context.tr.language,
                  suffixWidget: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          DText(
                            state.currentLanguageCode == AppConstants.enCode
                                ? AppConstants.usFlag
                                : AppConstants.egyptFlag,
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            state.currentLanguageCode == AppConstants.enCode
                                ? SolarIconsOutline.altArrowRight
                                : SolarIconsOutline.altArrowLeft,
                            size: 18.r,
                          ),
                        ],
                      );
                    },
                  ),
                  onTap: () {
                    if (AuthLocalDatasourceImpl().checkGuestMode()) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) {
                          return GuestModeBottomSheet();
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BlocProvider.value(
                            value: _userCubit,
                            child: const ChangeLanguageDialog(),
                          );
                        },
                      );
                    }
                  },
                ),
                ProfileCustomListTile(
                  iconData: SolarIconsOutline.bell,
                  title: context.tr.notifications,
                  disableOnTap: true,
                  suffixWidget: BlocConsumer<AppNotificationsCubit,
                      AppNotificationsState>(
                    listener: (context, state) {
                      if (state.permissionsState ==
                          PermissionsState.permanentlyDenied) {
                        showDialog(
                          routeSettings: const RouteSettings(
                            name: 'GalleryPermissionsDialogRoute',
                          ),
                          context: context,
                          builder: (context) {
                            return PermissionsDialog(
                              icon: Icons.image_outlined,
                              description: context.tr.galleryPermissionDialog,
                            );
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          IconSwitcher(
                            activeTrackColor: context.colorScheme.error,
                            activeIconColor: Colors.white,
                            activeThumbColor: Colors.white,
                            disabledTrackColor: ColorsManager.successColor,
                            loadingState: state.subscriptionState,
                            onChanged: (switched) async {
                              if (AuthLocalDatasourceImpl().checkGuestMode()) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: false,
                                  builder: (context) {
                                    return GuestModeBottomSheet();
                                  },
                                );
                              } else {
                                notificationsControl(
                                  isActive: switched,
                                  permissions: state.permissionsState,
                                );
                              }
                            },
                            activeIcon: SolarIconsOutline.bellOff,
                            disabledIcon: SolarIconsOutline.bell,
                            switcherValue: state.isSubscribedToNotifications,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ProfileCustomListTile(
                  iconData: SolarIconsOutline.moon,
                  title: context.tr.dazzifyTheme,
                  disableOnTap: true,
                  suffixWidget: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return IconSwitcher(
                        onChanged: (switched) {
                          context.read<SettingsCubit>().changeAppTheme();
                        },
                        activeIcon: SolarIconsOutline.sunrise,
                        disabledIcon: SolarIconsOutline.moon,
                        switcherValue: state.isDarkTheme,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            onTap: () {
              if (AuthLocalDatasourceImpl().checkGuestMode()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  builder: (context) {
                    return GuestModeBottomSheet();
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return BlocProvider.value(
                      value: _userCubit,
                      child: BlocListener<UserCubit, UserState>(
                        listener: (context, state) {
                          if (state.deleteUserAccountState == UiState.success) {
                            _tokensCubit.deleteUserTokens();
                          } else if (state.deleteUserAccountState == UiState.failure) {
                            DazzifyToastBar.showError(
                              message: state.errorMessage,
                            );
                          }
                        },
                        child: DazzifyDialog(
                          buttonTitle: context.tr.delete,
                          message: context.tr.deleteAccountMessage,
                          onTap: () => _userCubit.deleteUser(),
                        ),
                      ),
                    );
                  },
                );
              }
            },
            isOutLined: true,
            title: context.tr.deleteAccount,
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            onTap: () {
              AuthLocalDatasourceImpl().checkGuestMode()
                  ? _tokensCubit.deleteUserTokens()
                  : showDialog(
                      context: context,
                      builder: (context) {
                        return DazzifyDialog(
                          buttonTitle: context.tr.logOut,
                          message: context.tr.logOutMessage,
                          onTap: () => _tokensCubit.deleteUserTokens(),
                        );
                      },
                    );
            },
            title: AuthLocalDatasourceImpl().checkGuestMode()
                ? context.tr.goToLogin
                : context.tr.logOut,
            flexBetweenTextAndPrefix: 1,
            prefixWidget: AuthLocalDatasourceImpl().checkGuestMode()
                ? null
                : Icon(
                    SolarIconsOutline.logout_2,
                    size: 16.r,
                    color: context.colorScheme.onPrimary,
                  ),
          ),
        ],
      ),
    );
  }

  void notificationsControl({
    required bool isActive,
    required PermissionsState permissions,
  }) async {
    if (isActive && permissions == PermissionsState.granted) {
      await _notificationsCubit.subscribeToNotifications();
    } else if (permissions == PermissionsState.denied ||
        permissions == PermissionsState.permanentlyDenied) {
      _notificationsCubit.requestNotificationsPermissions();
    } else {
      _notificationsCubit.unSubscribeFromNotifications();
    }
  }
}
