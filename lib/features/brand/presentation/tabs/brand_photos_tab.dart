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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    // Load photos on initialization
    brandBloc.add(GetBrandImagesEvent(widget.brandId));
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

  double _parseAspectRatio(String aspectRatio) {
    if (aspectRatio.isEmpty) return 1.0;
    
    try {
      final parts = aspectRatio.split(':');
      if (parts.length == 2) {
        final width = double.tryParse(parts[0]) ?? 1.0;
        final height = double.tryParse(parts[1]) ?? 1.0;
        if (height != 0) {
          return width / height;
        }
      }
    } catch (e) {
      return 1.0;
    }
    
    return 1.0;
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
              return MasonryGridView.count(
                itemCount: state.photos.length + 1,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16).r,
                crossAxisCount: 3,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
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
                    final aspectRatio = _parseAspectRatio(card.aspectRatio ?? "");

                    switch (cardImageType) {
                      case CardImageType.none:
                        return const SizedBox.shrink();
                      case CardImageType.photo:
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: CardImage(
                            index: index,
                            imageUrl: card.thumbnail,
                            isAlbum: false,
                            aspectRatio: card.aspectRatio,
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
                          ),
                        );
                      case CardImageType.album:
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: CardImage(
                            index: index,
                            imageUrl: card.thumbnail,
                            isAlbum: true,
                            aspectRatio: card.aspectRatio,
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
                          ),
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
