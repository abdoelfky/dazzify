import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/home/logic/service_details/service_details_bloc.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';
import 'package:dazzify/features/shared/widgets/top_rated_card.dart';

class MoreLikeComponent extends StatelessWidget {
  const MoreLikeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0).r,
      child: Column(
        children: [
          SectionWidget(
            sectionTitle: context.tr.moreLike,
            fontColor: context.colorScheme.primary,
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 180.h,
            child: BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
              builder: (context, state) {
                switch (state.moreLikeThisState) {
                  case UiState.initial:
                  case UiState.loading:
                    return DazzifyLoadingShimmer(
                      dazzifyLoadingType: DazzifyLoadingType.listView,
                      scrollDirection: Axis.horizontal,
                      listViewItemCount: 2,
                      borderRadius: BorderRadius.circular(20).r,
                      cardWidth: 150.w,
                      cardHeight: 180.h,
                    );
                  case UiState.failure:
                    return DText(state.errorMessage);
                  case UiState.success:
                    return ListView.builder(
                      itemCount: state.moreLikeThisServices.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final favoriteCubit = context.read<FavoriteCubit>();
                        final service = state.moreLikeThisServices[index];
                        if (state.moreLikeThisServices.isEmpty) {
                          return EmptyDataWidget(
                            message: context.tr.noMoreLikeThis,
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsetsDirectional.only(start: 8.0.r),
                            child: BlocBuilder<FavoriteCubit, FavoriteState>(
                              builder: (context, state) {
                                return TopRatedServiceCard(
                                  title: service.title,
                                  image: service.image,
                                  height: 180.h,
                                  price: service.price,
                                  originalPrice: service.originalPrice,
                                  onTap: () {
                                    getIt<AppEventsLogger>().logEvent(
                                      event:
                                          AppEvents.serviceDetailsClickService,
                                      serviceId: service.id,
                                    );
                                    context.pushRoute(
                                      ServiceDetailsRoute(service: service),
                                    );
                                  },
                                  onFavoriteTap: () {
                                    favoriteCubit.addOrRemoveFromFavorite(
                                      favoriteService:
                                          service.toFavoriteModel(),
                                    );
                                  },
                                  isFavorite:
                                      state.favoriteIds.contains(service.id),
                                );
                              },
                            ),
                          );
                        }
                      },
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
