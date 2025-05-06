import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/brand/presentation/bottom_sheets/branch_selection_bottom_sheet.dart';
import 'package:dazzify/features/brand/presentation/bottom_sheets/chat_branches_sheet.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class BrandInfo extends StatelessWidget {
  final BrandModel brand;

  const BrandInfo({
    super.key,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: infoContainer(context),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 80.h,
          child: vendorInfo(context),
        ),
      ],
    );
  }

  Widget infoContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14).r,
      child: Container(
        height: 285.h,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10).r,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 38, right: 38, top: 16).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      DText(
                        context.tr.bookings,
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      DText(
                        brand.totalBookingsCount.toString(),
                        style: context.textTheme.bodyLarge,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      DText(
                        context.tr.rate,
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      DText(
                        brand.rating!.toString(),
                        style: context.textTheme.bodyLarge,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () {
                final BrandBloc brandBloc = context.read<BrandBloc>();
                brandBloc.add(GetBrandBranchesEvent(
                  brand.id,
                ));
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  routeSettings: const RouteSettings(
                    name: "BrandBranchesLocations",
                  ),
                  builder: (context) => BlocProvider.value(
                    value: brandBloc,
                    child: ChatBranchesSheet(
                      sheetType: BranchesSheetType.mapLocations,
                      brand: brand,
                    ),
                  ),
                );
              },
              child: DText(
                context.tr.viewBranches,
                style: context.textTheme.labelMedium!.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ).r,
              child: SizedBox(
                height: 120.h,
                child: Column(
                  children: [
                    DText(
                      brand.description!,
                      maxLines: 4,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        brandBooking(context),
                        SizedBox(width: 8.w),
                        messageBrand(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PrimaryButton brandBooking(BuildContext context) {
    return PrimaryButton(
      width: 252.w,
      height: 45.h,
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
          showBranchSelectionBottomSheet(
            context: context,
            brandId: brand.id,
            favoriteCubit: context.read<FavoriteCubit>(),
            isMultipleBooking: brand.allowMultipleServicesBook,
          );
        }
      },
      flexBetweenTextAndPrefix: 1,
      title: context.tr.book,
      prefixWidget: Icon(
        SolarIconsOutline.calendar,
        color: context.colorScheme.onPrimary,
        size: 16.r,
      ),
    );
  }

  IconButton messageBrand(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (AuthLocalDatasourceImpl().checkGuestMode()) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            builder: (context) {
              return GuestModeBottomSheet();
            },
          );
        } else {
          final BrandBloc brandBloc = context.read<BrandBloc>();
          brandBloc.add(
            GetBrandBranchesEvent(
              brand.id,
            ),
          );
          showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            routeSettings: const RouteSettings(
              name: "BrandBranchesChat",
            ),
            builder: (context) => BlocProvider.value(
              value: brandBloc,
              child: ChatBranchesSheet(
                sheetType: BranchesSheetType.chat,
                brand: brand,
              ),
            ),
          );
        }
      },
      icon: Icon(
        SolarIconsOutline.plain,
        color: context.colorScheme.primary,
        size: 24.r,
      ),
    );
  }

  Widget vendorInfo(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.pushRoute(
              DazzifyPhotoViewerRoute(
                isProfilePicture: true,
                name: brand.name,
                imageUrl: brand.logo,
                heroAnimationKey: AssetsManager.avatar,
              ),
            );
          },
          child: DazzifyCachedNetworkImage(
            imageUrl: brand.logo,
            width: 100.r,
            height: 100.r,
            borderRadius: 80,
            memCacheWidth: 100000,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DText(
              brand.name,
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(width: 2),
            if (brand.verified)
              Icon(
                SolarIconsBold.verifiedCheck,
                color: context.colorScheme.primary,
                size: 15.r,
              )
          ],
        ),
      ],
    );
  }
}
