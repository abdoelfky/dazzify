import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/home_brands/home_brands_bloc.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/top_rated_brand_card.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/animated_filter_button.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class TopRatedBrandsScreen extends StatefulWidget implements AutoRouteWrapper {
  const TopRatedBrandsScreen({super.key});

  @override
  State<TopRatedBrandsScreen> createState() => _TopRatedBrandsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<HomeBrandsBloc>(
      create: (context) =>
          getIt<HomeBrandsBloc>()..add(const GetTopRatedBrandsEvent()),
      child: this,
    );
  }
}

class _TopRatedBrandsScreenState extends State<TopRatedBrandsScreen> {
  final ScrollController _controller = ScrollController();
  late final HomeBrandsBloc homeBrandsBloc;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    homeBrandsBloc = context.read<HomeBrandsBloc>();
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() async {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      homeBrandsBloc.add(const GetTopRatedBrandsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: DazzifyAppBar(
                    isLeading: true,
                    title: context.tr.topRatedBrands,
                    horizontalPadding: 16.r,
                    onBackTap: () {
                      _logger.logEvent(
                          event: AppEvents.topratedClickBrandsBack);
                      context.maybePop();
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<HomeBrandsBloc, HomeBrandsState>(
                    builder: (context, state) {
                      switch (state.topRatedBrandsState) {
                        case UiState.initial:
                        case UiState.loading:
                          return DazzifyLoadingShimmer(
                            dazzifyLoadingType: DazzifyLoadingType.gridView,
                            gridViewItemCount: 12,
                            crossAxisCount: 3,
                            mainAxisSpacing: 6.h,
                            crossAxisSpacing: 6.w,
                            mainAxisExtent: 185.h,
                            widgetPadding: const EdgeInsets.all(8).r,
                          );
                        case UiState.failure:
                          return ErrorDataWidget(
                            errorDataType: DazzifyErrorDataType.screen,
                            message: state.errorMessage,
                            onTap: () {
                              homeBrandsBloc
                                  .add(const GetTopRatedBrandsEvent());
                            },
                          );
                        case UiState.success:
                          if (state.topRatedBrands.isEmpty) {
                            return EmptyDataWidget(
                              message: context.tr.noVendors,
                            );
                          } else {
                            return GridView.builder(
                              padding: const EdgeInsets.all(8).r,
                              controller: _controller,
                              itemCount: state.topRatedBrands.length + 1,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8.h,
                                childAspectRatio: (15 / 17),
                              ),
                              itemBuilder: (context, index) {
                                if (state.topRatedBrands.isNotEmpty &&
                                    index >= state.topRatedBrands.length) {
                                  if (state.hasTopRatedReachedMax) {
                                    return const SizedBox.shrink();
                                  } else {
                                    return LoadingAnimation(
                                      height: 50.h,
                                      width: 50.w,
                                    );
                                  }
                                } else {
                                  return TopRatedBrandCard(
                                    infoStart: 5.w,
                                    infoBottom: 12.h,
                                    nameStyle:
                                        context.textTheme.bodySmall!.copyWith(
                                      color: context.colorScheme.onPrimary,
                                    ),
                                    brand: state.topRatedBrands[index],
                                    onTap: () {
                                      _logger.logEvent(
                                        event:
                                            AppEvents.topratedClickBrandsBrand,
                                        brandId: state.topRatedBrands[index].id,
                                      );
                                      context.router.push(
                                        BrandProfileRoute(
                                          brand: state.topRatedBrands[index],
                                        ),
                                      );
                                    },
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
            if (mainCategories.isNotEmpty)
              PositionedDirectional(
                top: 40.h,
                end: 10.w,
                child: AnimatedFilterButton(
                  iconColor: context.colorScheme.primary,
                  onItemTap: (int index) {
                    homeBrandsBloc.add(
                      FilterTopRatedBrandsByCategory(
                        mainCategoryId: mainCategories[index].id,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }
}
