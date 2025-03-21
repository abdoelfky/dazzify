import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/popular_service_card.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';

class PopularServiceComponent extends StatelessWidget {
  const PopularServiceComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWidget(
          sectionTitle: context.tr.popularServices,
          sectionType: SectionType.withTextButton,
          onTextButtonTap: () {
            context.pushRoute(const PopularServicesRoute());
          },
        ),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.popularServicesState) {
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
                return Center(child: DText(state.errorMessage));
              case UiState.success:
                return SizedBox(
                  height: 180.h,
                  child: CustomFadeAnimation(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16).r,
                      itemCount: state.popularServices.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 8.w);
                      },
                      itemBuilder: (context, index) {
                        final service = state.popularServices[index];
                        return PopularServiceCard(
                          service: service,
                          onTap: () {
                            context.router.push(
                              ServiceDetailsRoute(service: service),
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
