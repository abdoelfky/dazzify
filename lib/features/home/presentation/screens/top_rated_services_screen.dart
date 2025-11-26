import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/services/services_bloc.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/top_rated_card.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class TopRatedServicesScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const TopRatedServicesScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return getIt<ServicesBloc>()..add(const GetTopRatedServicesEvent());
      },
      child: this,
    );
  }

  @override
  State<TopRatedServicesScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<TopRatedServicesScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final ServicesBloc servicesBloc;
  late final FavoriteCubit favoriteCubit;

  @override
  void initState() {
    servicesBloc = context.read<ServicesBloc>();
    favoriteCubit = context.read<FavoriteCubit>();
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  void _onScroll() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      servicesBloc.add(const GetTopRatedServicesEvent());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: DazzifyAppBar(
                horizontalPadding: 16.r,
                title: context.tr.topRatedServices,
                isLeading: true,
              ),
            ),
            Expanded(
              child: BlocBuilder<ServicesBloc, ServicesState>(
                builder: (context, state) {
                  switch (state.topRatedServicesState) {
                    case UiState.initial:
                    case UiState.loading:
                      return DazzifyLoadingShimmer(
                        dazzifyLoadingType: DazzifyLoadingType.gridView,
                        cardWidth: 100.w,
                        cardHeight: 150.h,
                        borderRadius: BorderRadius.circular(20).r,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 16.h,
                      );
                    case UiState.failure:
                      return ErrorDataWidget(
                        errorDataType: DazzifyErrorDataType.screen,
                        message: state.errorMessage,
                        onTap: () {
                          servicesBloc.add(const GetTopRatedServicesEvent());
                        },
                      );
                    case UiState.success:
                      if (state.topRatedServices.isEmpty) {
                        return EmptyDataWidget(
                          message: context.tr.noServices,
                        );
                      } else {
                        return GridView.builder(
                          controller: _scrollController,
                          itemCount: state.topRatedServices.length + 1,
                          padding: const EdgeInsets.only(
                            top: 24,
                            right: 16,
                            left: 16,
                          ).r,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 105 / 170,
                            crossAxisSpacing: 8.w,
                            mainAxisSpacing: 16.h,
                          ),
                          itemBuilder: (context, index) {
                            if (state.topRatedServices.isNotEmpty &&
                                index >= state.topRatedServices.length) {
                              if (state.hasTopRatedServicesReachedMax) {
                                return const SizedBox.shrink();
                              } else {
                                return const Center(
                                  child: LoadingAnimation(),
                                );
                              }
                            } else {
                              return TopRatedServiceCard(
                                image: state.topRatedServices[index].image,
                                title: state.topRatedServices[index].title,
                                onTap: () {
                                  context.pushRoute(
                                    ServiceDetailsRoute(
                                      service: state.topRatedServices[index],
                                    ),
                                  );
                                },
                                onFavoriteTap: () {
                                  context
                                      .read<FavoriteCubit>()
                                      .addOrRemoveFromFavorite(
                                        favoriteService: state
                                            .topRatedServices[index]
                                            .toFavoriteModel(),
                                      );
                                },
                                isFavorite: context
                                    .watch<FavoriteCubit>()
                                    .state
                                    .favoriteIds
                                    .contains(
                                      state.topRatedServices[index].id,
                                    ),
                                price: state.topRatedServices[index].price,
                              );
                            }
                          },
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
