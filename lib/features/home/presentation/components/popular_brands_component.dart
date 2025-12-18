import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/popular_brand_card.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularBrandsComponent extends StatelessWidget {
  const PopularBrandsComponent({super.key});

  AppEventsLogger get _logger => getIt<AppEventsLogger>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWidget(
          sectionTitle: context.tr.popularBrands,
          sectionType: SectionType.withTextButton,
          onTextButtonTap: () {
            _logger.logEvent(
              event: AppEvents.homeClickMorePopularBrands,
            );
            context.pushRoute(const PopularBrandsRoute());
          },
        ),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.popularBrandsState) {
              case UiState.initial:
              case UiState.loading:
                return SizedBox(
                  height: 90.h,
                  child: DazzifyLoadingShimmer(
                    dazzifyLoadingType: DazzifyLoadingType.listView,
                    scrollDirection: Axis.horizontal,
                    listViewItemCount: 3,
                    cardWidth: 260.w,
                    cardHeight: 90.h,
                    borderRadius: BorderRadiusDirectional.circular(16.r),
                  ),
                );
              case UiState.failure:
                return SizedBox(
                    width: context.screenWidth,
                    height: 190.h,
                    child: Container());
              case UiState.success:
                return SizedBox(
                  height: 95.h,
                  child: CustomFadeAnimation(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.popularBrands.length >= 20
                          ? 20
                          : state.popularBrands.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8).r,
                        child: PopularBrandCard(
                          brand: state.popularBrands[index],
                          onTap: () {
                            _logger.logEvent(
                              event: AppEvents.homeClickBrand,
                              brandId: state.popularBrands[index].id,
                            );
                            context.navigateTo(
                              BrandProfileRoute(
                                brand: state.popularBrands[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
            }
          },
        )
      ],
    );
  }
}
