import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/top_rated_brand_card.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';

class TopRatedBrandsComponent extends StatelessWidget {
  const TopRatedBrandsComponent({super.key});

  AppEventsLogger get _logger => getIt<AppEventsLogger>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWidget(
          sectionTitle: context.tr.topRatedBrands,
          sectionType: SectionType.withTextButton,
          onTextButtonTap: () {
            _logger.logEvent(
              event: AppEvents.homeClickMoreTopratedBrands,
            );
            context.pushRoute(const TopRatedBrandsRoute());
          },
        ),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.topRatedBrandsState) {
              case UiState.initial:
              case UiState.loading:
                return SizedBox(
                  height: 160.h,
                  child: DazzifyLoadingShimmer(
                    dazzifyLoadingType: DazzifyLoadingType.listView,
                    scrollDirection: Axis.horizontal,
                    listViewItemCount: 3,
                    cardWidth: 150.w,
                    cardHeight: 160.h,
                    borderRadius: BorderRadius.circular(8).r,
                  ),
                );
              case UiState.failure:
                return Center(child: DText(state.errorMessage));
              case UiState.success:
                return SizedBox(
                  height: 160.h,
                  child: CustomFadeAnimation(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16).r,
                      itemCount: state.topRatedBrands.length,
                      itemBuilder: (context, index) {
                        final item = state.topRatedBrands[index];
                        return TopRatedBrandCard(
                          brand: item,
                          onTap: () {
                            _logger.logEvent(
                              event: AppEvents.homeClickBrand,
                              brandId: item.id,
                            );
                            context.navigateTo(
                              BrandProfileRoute(
                                brand: state.topRatedBrands[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}
