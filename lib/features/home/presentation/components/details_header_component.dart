import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/home/logic/service_details/service_details_bloc.dart';
import 'package:dazzify/features/home/presentation/bottom-sheets/booking_branches_sheet.dart';
import 'package:dazzify/features/home/presentation/widgets/details_background_clipper.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class DetailsHeaderComponent extends StatefulWidget {
  final ServiceDetailsModel service;
  final BrandBranchesModel? branch;
  final bool isBooking;

  const DetailsHeaderComponent({
    super.key,
    required this.service,
    this.branch,
    required this.isBooking,
  });

  @override
  State<DetailsHeaderComponent> createState() => _DetailsHeaderComponentState();
}

class _DetailsHeaderComponentState extends State<DetailsHeaderComponent> {
  bool isBranchesSheetOpened = false;
  late String image;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    image = widget.service.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 500.h,
          child: Stack(
            children: [
              ClipPath(
                clipper: DetailsBackgroundClipper(),
                child: Container(
                  width: context.screenWidth,
                  height: 435.h,
                  color:
                      context.colorScheme.inversePrimary.withValues(alpha: 0.1),
                ),
              ),
              // PositionedDirectional(
              //   top: 100.h,
              //   start: 30.w,
              //   child: titleAndPrice(),
              // ),
              PositionedDirectional(
                top: 90.h,
                start: 30.w,
                child: SizedBox(
                  width: context.screenWidth -
                      100.w, // Or any specific width like 250.w
                  child: titleAndPrice(),
                ),
              ),

              PositionedDirectional(
                start: 20,
                bottom: 0,
                top: 185.h,
                child: buildServiceImages(),
              ),
              if (!widget.isBooking)
                PositionedDirectional(
                  end: 20,
                  bottom: 0,
                  top: 180.h,
                  child: favoriteAndBooking(),
                ),
              if (widget.isBooking)
                PositionedDirectional(
                  end: 20,
                  top: 240.h,
                  child: favoriteButton(),
                ),
            ],
          ),
        ),
        serviceInfo(),
        if (!widget.isBooking)
          GestureDetector(
            onTap: () {
              _logger.logEvent(
                event: AppEvents.serviceDetailsClickBrand,
                brandId: widget.service.brand.id,
              );
              context.pushRoute(
                BrandProfileRoute(
                  brandSlug: widget.service.brand.username,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10).r,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(360).r,
                    child: DazzifyCachedNetworkImage(
                      imageUrl: widget.service.brand.logo,
                      fit: BoxFit.cover,
                      height: 40.h,
                      width: 40.h,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DText(
                            widget.service.brand.name,
                            style: context.textTheme.bodyMedium!
                                .copyWith(color: context.colorScheme.primary),
                          ),
                          if (widget.service.brand.verified)
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: 8.0.r),
                              child: Icon(
                                SolarIconsBold.verifiedCheck,
                                color: context.colorScheme.primary,
                                size: 15.r,
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 220.w,
                        child: DText(
                          context.tr.serviceProvider,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget titleAndPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DText(
          widget.service.title.toUpperCase(),
          style: context.textTheme.titleLarge!.copyWith(
            color: context.colorScheme.primary,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        RichText(
          text: TextSpan(
            text: '${reformatPriceWithCommas(widget.service.price)} ',
            style: context.textTheme.titleMedium!,
            children: [
              TextSpan(
                text: context.tr.currency,
                style: context.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildServiceImages() {
    return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(80).r,
            topEnd: const Radius.circular(32).r,
            bottomStart: const Radius.circular(32).r,
            bottomEnd: const Radius.circular(80).r,
          ),
          child: DazzifyCachedNetworkImage(
            width: 215.w,
            height: 280.h,
            imageUrl: state.service.image,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget favoriteButton() {
    return RotatedBox(
      quarterTurns: 3,
      child: PrimaryButton(
        width: 180.w,
        height: 60.h,
        onTap: () {},
        suffixWidget: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            return RotatedBox(
              quarterTurns: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FavoriteIconButton(
                  isFavorite: state.favoriteIds.contains(widget.service.id),
                  hasBackGround: false,
                  borderRadius: 12.r,
                  onFavoriteTap: () {
                    final favoriteCubit = context.read<FavoriteCubit>();
                    final isFavorite = favoriteCubit.state.favoriteIds
                        .contains(widget.service.id);
                    if (isFavorite) {
                      _logger.logEvent(
                        event: AppEvents.serviceDetailsClickRemoveFavourite,
                        serviceId: widget.service.id,
                      );
                    } else {
                      _logger.logEvent(
                        event: AppEvents.serviceDetailsClickAddFavourite,
                        serviceId: widget.service.id,
                      );
                    }
                    favoriteCubit.addOrRemoveFromFavorite(
                      favoriteService: widget.service.toFavoriteModel(),
                    );
                  },
                  iconSize: 34.r,
                ),
              ),
            );
          },
        ),
        textColor: context.colorScheme.primary,
        isOutLined: true,
        title: context.tr.addToFavorite,
      ),
    );
  }

  Widget favoriteAndBooking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20.h),
        BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            return FavoriteIconButton(
              isFavorite: state.favoriteIds.contains(widget.service.id),
              backgroundWidth: 60.r,
              backgroundHeight: 60.r,
              backgroundOpacity: 0.16,
              borderRadius: 12.r,
              onFavoriteTap: () {
                final favoriteCubit = context.read<FavoriteCubit>();
                final isFavorite =
                    favoriteCubit.state.favoriteIds.contains(widget.service.id);
                if (isFavorite) {
                  _logger.logEvent(
                    event: AppEvents.serviceDetailsClickRemoveFavourite,
                    serviceId: widget.service.id,
                  );
                } else {
                  _logger.logEvent(
                    event: AppEvents.serviceDetailsClickAddFavourite,
                    serviceId: widget.service.id,
                  );
                }
                favoriteCubit.addOrRemoveFromFavorite(
                  favoriteService: widget.service.toFavoriteModel(),
                );
              },
              iconSize: 34.r,
            );
          },
        ),
        SizedBox(height: 20.h),
        RotatedBox(
          quarterTurns: 3,
          child: PrimaryButton(
            width: 136.w,
            height: 60.h,
            onTap: () async {
              _logger.logEvent(
                event: AppEvents.serviceDetailsClickBook,
                serviceId: widget.service.id,
              );
              if (widget.branch != null) {
                context.pushRoute(ServiceAvailabilityRoute(
                  service: widget.service,
                  branchId: widget.branch!.id,
                  branchName: widget.branch!.name,
                  location: widget.branch!.location,
                ));
              } else {
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
                    routeSettings:
                        const RouteSettings(name: "BookingBranchesSheet"),
                    builder: (context) => BookingBranchesSheet(
                      service: widget.service,
                    ),
                  );
                }
              }
            },
            prefixWidget: Icon(
              SolarIconsOutline.calendar,
              color: context.colorScheme.primary,
              size: 16.r,
            ),
            textColor: context.colorScheme.primary,
            isOutLined: true,
            title: context.tr.bookService,
          ),
        ),
      ],
    );
  }

  Widget serviceInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DText(
            context.tr.aboutService,
            style: context.textTheme.bodyLarge!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 299.w,
            child: DText(
              maxLines: 50,
              widget.service.description,
              style: context.textTheme.bodyMedium!
                  .copyWith(color: context.colorScheme.outline),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                SolarIconsOutline.alarm,
                color: context.colorScheme.outline,
                size: 14.r,
              ),
              SizedBox(width: 8.w),
              DText(
                "${widget.service.duration} ${context.tr.min}",
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
              Spacer(),
              Icon(
                SolarIconsOutline.history3,
                color: context.colorScheme.outline,
                size: 14.r,
              ),
              SizedBox(width: 8.w),
              DText(
                "${context.tr.lateTime}: ${widget.service.lateLimit}",
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
              Spacer(),
              Icon(
                SolarIconsOutline.mapPoint,
                color: context.colorScheme.outline,
                size: 14.r,
              ),
              SizedBox(width: 8.w),
              DText(
                widget.service.locationAvailability,
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
