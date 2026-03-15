import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/category_card.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesComponent extends StatelessWidget {
  const CategoriesComponent({super.key});
  AppEventsLogger get _logger => getIt<AppEventsLogger>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0).r,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          switch (state.categoriesState) {
            case UiState.initial:
            case UiState.loading:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16).r,
                child: DazzifyLoadingShimmer(
                  dazzifyLoadingType: DazzifyLoadingType.custom,
                  cardWidth: context.screenWidth,
                  cardHeight: 100.h,
                  borderRadius: BorderRadius.circular(16).r,
                ),
              );
            case UiState.failure:
              return const SizedBox.shrink();
            case UiState.success:
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.tr.categories,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 120.h,
                      child: ListView.builder(
                        itemCount: state.mainCategories.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final category = state.mainCategories[index];
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SizedBox(
                              width: 75.w,
                              child: CategoryCard(
                                onTap: () {
                                  _logger.logEvent(
                                    event: AppEvents.homeClickMaincategory,
                                    mainCategoryId: category.id,
                                  );
                                  context.pushRoute(
                                    CategoryRoute(
                                      categoryName: category.name,
                                      categoryId: category.id,
                                    ),
                                  );
                                },
                                imageUrl: category.image,
                                title: category.name,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
