import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';
import 'package:dazzify/features/shared/widgets/top_rated_card.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopServicesComponent extends StatelessWidget {
  const TopServicesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWidget(
          sectionTitle: context.tr.topRatedServices,
          sectionType: SectionType.withTextButton,
          onTextButtonTap: () {
            context.pushRoute(const TopRatedServicesRoute());
          },
        ),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.topRatedServicesState) {
              case UiState.initial:
              case UiState.loading:
                return SizedBox(
                  height: 180.h,
                  child: DazzifyLoadingShimmer(
                    dazzifyLoadingType: DazzifyLoadingType.listView,
                    scrollDirection: Axis.horizontal,
                    listViewItemCount: 3,
                    cardWidth: 150.w,
                    cardHeight: 180.h,
                    borderRadius: BorderRadius.circular(8).r,
                  ),
                );
              case UiState.failure:
                return SizedBox(
                  width: context.screenWidth,
                  height: 190.h,
                );
              case UiState.success:
                return SizedBox(
                  width: context.screenWidth,
                  height: 180.h,
                  child: ListView.separated(
                    itemCount: state.topRatedServices.length >= 20
                        ? 20
                        : state.topRatedServices.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12).r,
                    itemBuilder: (context, index) {
                      ServiceDetailsModel service =
                          state.topRatedServices[index];
                      return BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          return TopRatedServiceCard(
                            height: 180.h,
                            title: service.title,
                            image: service.image,
                            price: service.price,
                            onTap: () {
                              context.pushRoute(
                                ServiceDetailsRoute(service: service),
                              );
                            },
                            onFavoriteTap: () {
                              context
                                  .read<FavoriteCubit>()
                                  .addOrRemoveFromFavorite(
                                    favoriteService: service.toFavoriteModel(),
                                  );
                            },
                            isFavorite: state.favoriteIds.contains(service.id),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      width: 12.w,
                    ),
                  ),
                );
            }
          },
        ),
        Container()
      ],
    );
  }
}
