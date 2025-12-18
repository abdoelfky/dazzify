import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/logic/booking_from_media/booking_from_media_cubit.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/service_card.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class MyFavoriteScreen extends StatefulWidget implements AutoRouteWrapper {
  const MyFavoriteScreen({super.key});

  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BookingFromMediaCubit>(),
        ),
      ],
      child: this,
    );
  }
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> {
  bool isLoading = false;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BookingFromMediaCubit, BookingFromMediaState>(
        listener: (context, state) =>
            bookingFromMediaCubitListener(state, context),
        builder: (context, state) {
          return DazzifyOverlayLoading(
            isLoading: isLoading,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: DazzifyAppBar(
                    isLeading: true,
                    title: context.tr.myFavorite,
                    onBackTap: () {
                      _logger.logEvent(event: AppEvents.favouritesClickBack);
                      context.maybePop();
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      if (state.favoriteServiceList.isEmpty) {
                        return EmptyDataWidget(
                          message: context.tr.noFavorites,
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 210.h,
                            crossAxisSpacing: 10.h,
                            mainAxisSpacing: 10.h,
                          ),
                          padding: const EdgeInsets.all(12).r,
                          itemCount: state.favoriteServiceList.length,
                          itemBuilder: (context, index) {
                            final item = state.favoriteServiceList[index];
                            return FavoriteCard(
                              image: item.image,
                              title: item.title,
                              price:
                                  '${reformatPriceWithCommas(item.price)} ${context.tr.currency}',
                              onTap: () {
                                context
                                    .read<BookingFromMediaCubit>()
                                    .getSingleServiceDetails(
                                      serviceId: item.id,
                                    );
                              },
                              onFavoriteTap: () {
                                _logger.logEvent(
                                  event:
                                      AppEvents.favouritesClickRemoveFavourite,
                                  serviceId: item.id,
                                );
                                context
                                    .read<FavoriteCubit>()
                                    .addOrRemoveFromFavorite(
                                      favoriteService: item,
                                    );
                              },
                              isFavorite: true,
                              imageHeight: 150.h,
                              imageWidth: 100.w,
                              borderRadius: 8,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void bookingFromMediaCubitListener(
    BookingFromMediaState state,
    BuildContext context,
  ) {
    switch (state.blocState) {
      case UiState.initial:
      case UiState.loading:
        isLoading = true;
      case UiState.success:
        context.pushRoute(ServiceDetailsRoute(service: state.service));
        isLoading = false;
      case UiState.failure:
        isLoading = false;
        DazzifyToastBar.showError(
          message: state.errorMessage,
        );
    }
  }
}
