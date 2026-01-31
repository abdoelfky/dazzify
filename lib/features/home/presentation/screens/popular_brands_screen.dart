import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/home_brands/home_brands_bloc.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/animated_filter_button.dart';
import 'package:dazzify/features/shared/widgets/brand_card.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class PopularBrandsScreen extends StatefulWidget implements AutoRouteWrapper {
  const PopularBrandsScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<HomeBrandsBloc>(
      create: (context) => getIt<HomeBrandsBloc>()
        ..add(
          const GetPopularBrandsEvent(),
        ),
      child: this,
    );
  }

  @override
  State<PopularBrandsScreen> createState() => _PopularBrandsScreenState();
}

class _PopularBrandsScreenState extends State<PopularBrandsScreen> {
  final ScrollController _controller = ScrollController();
  late final HomeBrandsBloc allBrandsBloc;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    allBrandsBloc = context.read<HomeBrandsBloc>();
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() async {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      allBrandsBloc.add(const GetPopularBrandsEvent());
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          _logger.logEvent(event: AppEvents.popularClickBrandsBack);
        }
      },
      child: Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: DazzifyAppBar(
                  isLeading: true,
                  title: context.tr.popularBrands,
                  horizontalPadding: 16.r,
                  onBackTap: () {
                    _logger.logEvent(event: AppEvents.popularClickBrandsBack);
                    context.maybePop();
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<HomeBrandsBloc, HomeBrandsState>(
                  builder: (context, state) {
                    switch (state.popularBrandsState) {
                      case UiState.initial:
                      case UiState.loading:
                        return const DazzifyLoadingShimmer(
                          dazzifyLoadingType: DazzifyLoadingType.brands,
                        );
                      case UiState.failure:
                        return ErrorDataWidget(
                          errorDataType: DazzifyErrorDataType.screen,
                          message: state.errorMessage,
                          onTap: () {
                            allBrandsBloc.add(const GetPopularBrandsEvent());
                          },
                        );
                      case UiState.success:
                        if (state.popularBrands.isEmpty) {
                          return EmptyDataWidget(
                            height: 10.r,
                            width: 10.r,
                            message: context.tr.noVendors,
                          );
                        } else {
                          return ListView.separated(
                            controller: _controller,
                            itemCount: state.popularBrands.length + 1,
                            padding: const EdgeInsets.only(
                              top: 24,
                              right: 16,
                              left: 16,
                            ).r,
                            itemBuilder: (context, index) {
                              if (state.popularBrands.isNotEmpty &&
                                  index >= state.popularBrands.length) {
                                if (state.hasPopularReachedMax) {
                                  return const SizedBox.shrink();
                                } else {
                                  return SizedBox(
                                    height: 70.r,
                                    width: context.screenWidth,
                                    child: LoadingAnimation(
                                      height: 50.h,
                                      width: 50.w,
                                    ),
                                  );
                                }
                              } else {
                                return BrandCard(
                                  brand: state.popularBrands[index],
                                  onTap: () {
                                    _logger.logEvent(
                                      event: AppEvents.popularClickBrandsBrand,
                                      brandId: state.popularBrands[index].id,
                                    );
                                    context.router.push(
                                      BrandProfileRoute(
                                        brand: state.popularBrands[index],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    SizedBox(height: 16.h),
                          );
                        }
                    }
                  },
                ),
              )
            ],
          ),
          if (mainCategories.isNotEmpty)
            PositionedDirectional(
              top: 40.h,
              end: 10.w,
              child: AnimatedFilterButton(
                iconColor: context.colorScheme.primary,
                onItemTap: (int index) {
                  allBrandsBloc.add(
                    FilterPopularBrandsByCategory(
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
}
