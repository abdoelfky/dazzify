import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/category/category_bloc.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
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
class CategoryScreen extends StatefulWidget implements AutoRouteWrapper {
  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  final String categoryName;
  final String categoryId;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryBloc>()
        ..add(GetCategoryBrandsEvent(categoryId: categoryId)),
      child: this,
    );
  }
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _controller = ScrollController();
  late final CategoryBloc categoryBloc;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    categoryBloc = context.read<CategoryBloc>();
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() async {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      categoryBloc.add(
        GetCategoryBrandsEvent(categoryId: widget.categoryId),
      );
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
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: DazzifyAppBar(
            isLeading: true,
            title: widget.categoryName,
            horizontalPadding: 16.r,
            onBackTap: () {
              _logger.logEvent(event: AppEvents.maincategoryClickBack);
              context.maybePop();
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              switch (state.blocState) {
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
                      categoryBloc.add(
                        GetCategoryBrandsEvent(categoryId: widget.categoryId),
                      );
                    },
                  );
                case UiState.success:
                  if (state.brands.isEmpty) {
                    return Expanded(
                      child: EmptyDataWidget(
                        message: context.tr.noVendors,
                      ),
                    );
                  } else {
                    return ListView.separated(
                      controller: _controller,
                      itemCount: state.brands.length + 1,
                      padding: const EdgeInsets.only(
                        top: 24,
                        bottom: 90,
                        right: 16,
                        left: 16,
                      ).r,
                      itemBuilder: (context, index) {
                        debugPrint("INDEX : $index");
                        if (index >= state.brands.length) {
                          if (state.hasReachedMax) {
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
                            brand: state.brands[index],
                            onTap: () {
                              _logger.logEvent(
                                event: AppEvents.maincategoryClickBrand,
                                brandId: state.brands[index].id,
                              );
                              context.router.push(
                                BrandProfileRoute(
                                  brand: state.brands[index],
                                ),
                              );
                            },
                          );
                        }
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: 16.h),
                    );
                  }
              }
            },
          ),
        ),
      ],
    ));
  }
}
