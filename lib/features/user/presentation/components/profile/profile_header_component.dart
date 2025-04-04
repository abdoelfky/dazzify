import 'dart:math' as math;
import 'dart:ui';

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/shared/widgets/dazzify_rounded_picture.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/permission_dialog.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/features/user/presentation/bottom_sheets/profile_update_sheet.dart';

class ProfileHeaderComponent extends StatefulWidget {
  const ProfileHeaderComponent({super.key});

  @override
  State<ProfileHeaderComponent> createState() => _ProfileHeaderComponentState();
}

class _ProfileHeaderComponentState extends State<ProfileHeaderComponent> {
  late UserCubit _profileCubit;

  @override
  void initState() {
    _profileCubit = context.read<UserCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: Image.asset(
            AssetsManager.userDefaultCoverPath,
            width: context.screenWidth,
            height: 230.h,
            color: Colors.black.withValues(alpha: 0.1),
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.overlay,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 60.h,
          child: BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {
              if (state.photoPermissions ==
                  PermissionsState.permanentlyDenied) {

                showDialog(
                  routeSettings: const RouteSettings(
                    name: 'PermissionsDialogRoute',
                  ),
                  context: context,
                  builder: (context) {

                    return PermissionsDialog(
                      icon: Icons.photo_outlined,
                      description: context.tr.galleryPermissionDialog,
                    );
                  },
                );
              }
            },
            builder: (context, state) {
              switch (state.updateProfileImageState) {
                case UiState.failure:
                  return const Center(
                    child: DazzifyRoundedPicture(
                      imageUrl: null,
                      hasEditButton: false,
                    ),
                  );
                case UiState.loading:
                case UiState.initial:
                case UiState.success:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          return DazzifyRoundedPicture(
                            imageUrl: state.userModel.picture ?? "",
                            hasEditButton: state.userModel.picture != null,
                            onEditButtonTap: () {
                              if (AuthLocalDatasourceImpl().checkGuestMode()){
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: false,
                                  builder: (context) {

                                    return  GuestModeBottomSheet();
                                  },
                                );
                              }else {
                                context.read<UserCubit>()..updateProfileImage();
                              }},
                          );
                        },
                      ),
                      SizedBox(height: 8.r),
                      DText(
                        state.userModel.fullName,
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  );
              }
            },
          ),
        ),
        PositionedDirectional(
          top: 0,
          bottom: 0,
          end: 16.w,
          child: GestureDetector(
            onTap: () {
              if (AuthLocalDatasourceImpl().checkGuestMode()){
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  builder: (context) {

                    return  GuestModeBottomSheet();
                  },
                );
              }else {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  routeSettings: const RouteSettings(
                    name: "ProfileUpdateSheet",
                  ),
                  builder: (context) {
                    return BlocProvider.value(
                      value: _profileCubit,
                      child: const ProfileUpdateSheet(),
                    );
                  },
                );
              }
            },
            child: Transform.rotate(
              angle: (90 * math.pi) / 180,
              child: Icon(
                SolarIconsOutline.menuDots,
                size: 24.r,
              ),
            ),
          ),
        )
      ],
    );
  }
}
