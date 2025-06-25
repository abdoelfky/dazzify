      import 'package:auto_route/auto_route.dart';
      import 'package:dazzify/core/util/enums.dart';
      import 'package:dazzify/core/util/extensions.dart';
      import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
      import 'package:dazzify/features/shared/animations/loading_animation.dart';
      import 'package:dazzify/features/shared/widgets/card_reels.dart';
      import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
      import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
      import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
      import 'package:dazzify/settings/router/app_router.dart';
      import 'package:flutter/material.dart';
      import 'package:flutter_bloc/flutter_bloc.dart';
      import 'package:flutter_screenutil/flutter_screenutil.dart';

      class BrandReelsTab extends StatefulWidget {
        final String brandId;
        final TabController tabController;
        final ScrollController scrollController;

        const BrandReelsTab({
          super.key,
          required this.brandId,
          required this.tabController,
          required this.scrollController,
        });

        @override
        State<BrandReelsTab> createState() => _BrandReelsTabState();
      }

      class _BrandReelsTabState extends State<BrandReelsTab>
          with AutomaticKeepAliveClientMixin {
        late final BrandBloc brandBloc;

        @override
        bool get wantKeepAlive => true;

        @override
        void initState() {
          brandBloc = context.read<BrandBloc>();
          widget.scrollController.addListener(_onScroll);
          brandBloc.add(GetBrandReelsEvent(widget.brandId));
          super.initState();
        }

        void _onScroll() {
          if (widget.tabController.index == 1) {
            final maxScroll = widget.scrollController.position.maxScrollExtent;
            final currentScroll = widget.scrollController.offset;
            if (currentScroll >= (maxScroll * 0.8)) {
              brandBloc.add(GetBrandReelsEvent(widget.brandId));
            }
          }
        }

        @override
        Widget build(BuildContext context) {
          super.build(context);
          return BlocBuilder<BrandBloc, BrandState>(
            builder: (context, state) {
              switch (state.reelsState) {
                case UiState.initial:
                case UiState.loading:
                  return DazzifyLoadingShimmer(
                    dazzifyLoadingType: DazzifyLoadingType.gridView,
                    widgetPadding: const EdgeInsets.symmetric(horizontal: 16).r,
                    cardWidth: 150.w,
                    cardHeight: 180.h,
                    mainAxisExtent: 180.h,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                  );
                case UiState.failure:
                  return ErrorDataWidget(
                    errorDataType: DazzifyErrorDataType.screen,
                    message: state.errorMessage,
                    onTap: () {
                      brandBloc.add(GetBrandReelsEvent(widget.brandId));
                    },
                  );
                case UiState.success:
                  if (state.reels.isEmpty) {
                    return EmptyDataWidget(
                      message: context.tr.emptyVendorReels,
                    );
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16).r,
                      itemCount: state.reels.length + 1,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 180.h,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                      ),
                      itemBuilder: (context, index) {
                        if (state.reels.isNotEmpty && index >= state.reels.length) {
                          if (state.hasReelsReachedMax) {
                            return const SizedBox.shrink();
                          } else {
                            return SizedBox(
                              height: 70.h,
                              width: context.screenWidth,
                              child: LoadingAnimation(
                                height: 50.h,
                                width: 50.w,
                              ),
                            );
                          }
                        } else {
                          // print(state.reels[index].viewsCount);
                          return CardReels(
                            thumbnailUrl: state.reels[index].thumbnail,
                            viewCount: state.reels[index].viewsCount,
                            onTap: () {
                              context.pushRoute(
                                BrandReelsRoute(
                                  index: index,
                                  vendorBloc: brandBloc,
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
          );
        }
      }
