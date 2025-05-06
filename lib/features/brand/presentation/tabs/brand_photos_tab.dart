import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/card_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandPhotosTab extends StatefulWidget {
  final String brandId;
  final String brandName;
  final TabController tabController;
  final ScrollController scrollController;

  const BrandPhotosTab({
    super.key,
    required this.brandId,
    required this.brandName,
    required this.tabController,
    required this.scrollController,
  });

  @override
  State<BrandPhotosTab> createState() => _BrandPhotosTabState();
}

class _BrandPhotosTabState extends State<BrandPhotosTab>
    with AutomaticKeepAliveClientMixin {
  // final ScrollController _scrollController = ScrollController();
  late final BrandBloc brandBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    brandBloc = context.read<BrandBloc>();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.tabController.index == 0) {
      final maxScroll = widget.scrollController.position.maxScrollExtent;
      final currentScroll = widget.scrollController.offset;
      if (currentScroll >= (maxScroll * 0.8)) {
        brandBloc.add(GetBrandImagesEvent(widget.brandId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        switch (state.photosState) {
          case UiState.initial:
          case UiState.loading:
            return DazzifyLoadingShimmer(
              dazzifyLoadingType: DazzifyLoadingType.gridView,
              cardWidth: 104.w,
              cardHeight: 120.h,
            );
          case UiState.failure:
            return ErrorDataWidget(
              errorDataType: DazzifyErrorDataType.screen,
              message: state.errorMessage,
              onTap: () {
                brandBloc.add(GetBrandImagesEvent(widget.brandId));
              },
            );
          case UiState.success:
            if (state.photos.isEmpty) {
              return EmptyDataWidget(
                message: context.tr.emptyVendorImages,
              );
            } else {
              return GridView.builder(
                // controller: _scrollController,
                itemCount: state.photos.length + 1,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16).r,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 150.h,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemBuilder: (context, index) {
                  if (index >= state.photos.length && state.photos.isNotEmpty) {
                    if (state.hasPhotosReachedMax) {
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
                    final card = state.photos[index];
                    final cardImageType = getCardImageType(card.type);

                    switch (cardImageType) {
                      case CardImageType.none:
                        return const SizedBox.shrink();
                      case CardImageType.photo:
                        return CardImage(
                          index: index,
                          imageUrl: card.thumbnail,
                          isAlbum: false,
                          onTap: () {
                            context.pushRoute(
                              BrandPostsRoute(
                                brandBloc: brandBloc,
                                brandId: widget.brandId,
                                brandName: widget.brandName,
                                photoIndex: index,
                              ),
                            );
                          },
                        );
                      case CardImageType.album:
                        return CardImage(
                          index: index,
                          imageUrl: card.thumbnail,
                          isAlbum: true,
                          onTap: () {
                            context.pushRoute(
                              BrandPostsRoute(
                                brandBloc: brandBloc,
                                brandId: widget.brandId,
                                brandName: widget.brandName,
                                photoIndex: index,
                              ),
                            );
                          },
                        );
                    }
                  }
                },
              );
            }
        }
      },
    );
  }
}
