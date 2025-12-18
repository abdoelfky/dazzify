import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/home/presentation/widgets/popular_service_card_clipper.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';
import 'package:dazzify/features/shared/widgets/widget_direction.dart';

class PopularServiceCard extends StatelessWidget {
  final ServiceDetailsModel service;
  final double? iconTop;
  final double? iconEnd;
  final TextStyle? nameStyle;
  final void Function() onTap;
  final void Function()? onFavoriteTap;
  final bool? isFavorite;

  const PopularServiceCard({
    super.key,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite,
    required this.service,
    this.iconTop,
    this.iconEnd,
    this.nameStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16).r,
        child: Stack(
          children: [
            DazzifyCachedNetworkImage(
              imageUrl: service.image,
              height: 180.h,
              width: 150.w,
              fit: BoxFit.cover,
            ),
            PositionedDirectional(
              bottom: 0,
              child: WidgetDirection(
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: ServiceClipper(),
                      child: Container(
                        width: 150.w,
                        height: 64.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(16).r,
                            bottomRight: const Radius.circular(16).r,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              bottom: 12.h,
              start: 12.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DText(
                    service.title.length > 15
                        ? '${service.title.substring(0, 15)}...'
                        : service.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: nameStyle ??
                        context.textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  DText(
                    '${reformatPriceWithCommas(service.price)} ${context.tr.egp}',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: iconTop ?? 8.h,
              end: iconEnd ?? 8.w,
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  final logger = getIt<AppEventsLogger>();
                  final isFavorite = state.favoriteIds.contains(service.id);
                  return FavoriteIconButton(
                    iconSize: 18.r,
                    backgroundColor:
                        context.colorScheme.onPrimary.withValues(alpha: 0.6),
                    favoriteColor: context.colorScheme.primary,
                    unFavoriteColor: context.colorScheme.primary,
                    isFavorite: isFavorite,
                    onFavoriteTap: () {
                      if (isFavorite) {
                        logger.logEvent(
                          event: AppEvents.homeClickRemoveFavourite,
                          serviceId: service.id,
                        );
                      } else {
                        logger.logEvent(
                          event: AppEvents.homeClickAddFavourite,
                          serviceId: service.id,
                        );
                      }
                      final favoriteCubit = context.read<FavoriteCubit>();
                      favoriteCubit.addOrRemoveFromFavorite(
                        favoriteService: service.toFavoriteModel(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
