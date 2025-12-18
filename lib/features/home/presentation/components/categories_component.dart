import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/data/models/category_model.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/category_card.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 16.0).r,
      child: Column(
        children: [
          SectionWidget(sectionTitle: context.tr.categories),
          SizedBox(height: 16.h),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              switch (state.categoriesState) {
                case UiState.initial:
                case UiState.loading:
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8).r,
                    child: DazzifyLoadingShimmer(
                      dazzifyLoadingType: DazzifyLoadingType.custom,
                      cardWidth: context.screenWidth,
                      cardHeight: 84.h,
                      borderRadius: BorderRadius.circular(16).r,
                    ),
                  );
                case UiState.failure:
                  return SizedBox(
                    height: 85.h,
                    width: context.screenWidth,
                  );
                case UiState.success:
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8).r,
                    child: Container(
                      height: 84.h,
                      width: context.screenWidth,
                      decoration: BoxDecoration(
                        color: context.colorScheme.inversePrimary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16).r,
                      ),
                      child: ListView.builder(
                        itemCount: state.mainCategories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          CategoryModel category = state.mainCategories[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ).r,
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
                          );
                        },
                      ),
                    ),
                  );
              }
            },
          )
        ],
      ),
    );
  }
}
