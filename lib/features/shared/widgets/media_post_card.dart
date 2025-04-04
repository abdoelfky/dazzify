import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:dazzify/core/framework/dazzify_drop_down.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/home/presentation/widgets/animated_indicator.dart';
import 'package:dazzify/features/reels/data/repositories/reels_repository.dart';
import 'package:dazzify/features/shared/bottom_sheets/report_bottom_sheet.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/widgets/animated_read_more_text.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MediaPostCard extends StatefulWidget {
  final MediaModel brandMedia;
  final bool isLiked;
  final void Function() onLikeTap;
  final void Function() onCommentTap;
  final void Function() onSendServiceTap;
  final void Function() onBookingTap;
  final void Function()? onBrandTap;

  const MediaPostCard({
    super.key,
    required this.brandMedia,
    required this.isLiked,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSendServiceTap,
    required this.onBookingTap,
    this.onBrandTap,
  });

  @override
  State<MediaPostCard> createState() => _MediaPostCardState();
}

class _MediaPostCardState extends State<MediaPostCard> {
  ValueNotifier<bool>? isCollapsed;
  late List<VideoPlayerController?> _videoControllers;
  late List<ChewieController?> _chewieControllers;
  late final ValueNotifier<int> _indicatorIndex;
  late bool didAddView = false;

  @override
  void initState() {
    _videoControllers = List<VideoPlayerController?>.filled(
        widget.brandMedia.mediaItems.length, null);
    _chewieControllers = List<ChewieController?>.filled(
        widget.brandMedia.mediaItems.length, null);
    _indicatorIndex = ValueNotifier<int>(0);
    super.initState();
  }

  Future<void> _initializeVideoController(int index) async {
    if (_videoControllers[index] == null) {
      final videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.brandMedia.mediaItems[index].itemUrl),
      );
      await videoController.initialize();
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: true,
        looping: true,
        showControls: false,
        aspectRatio: 4 / 3,
      );

      setState(() {
        _videoControllers[index] = videoController;
        _chewieControllers[index] = chewieController;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.brandMedia.id),
      onVisibilityChanged: (visibilityInfo) async {
        if (visibilityInfo.visibleFraction > 0 && !didAddView) {
          final response = await getIt<ReelsRepository>()
              .addViewForMedia(mediaId: widget.brandMedia.id);
          response.fold(
            (left) {},
            (right) => didAddView = true,
          );
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16).r,
            decoration: BoxDecoration(
              color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16).r,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                postHeader(),
                postMedia(),
                postButtons(),
                likesAndCaption(),
              ],
            ),
          ),
          PositionedDirectional(
            top: 15.r,
            end: 30.r,
            child: DazzifyIconMenu(
              removeInitialBackground: true,
              options: [
                MenuOption(
                  icon: SolarIconsOutline.calendar,
                  onTap: widget.onBookingTap,
                ),
                MenuOption(
                  icon: SolarIconsOutline.dangerCircle,
                  onTap: () {
                    if (AuthLocalDatasourceImpl().checkGuestMode()) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) {
                          return GuestModeBottomSheet();
                        },
                      );
                    }else {
                      showReportBottomSheet(
                      context: context,
                      id: widget.brandMedia.id,
                      type: "media",
                    );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget postHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
      ).r,
      child: GestureDetector(
        onTap: widget.onBrandTap,
        child: Row(
          children: [
            ClipOval(
              child: DazzifyCachedNetworkImage(
                width: 38.r,
                height: 38.r,
                imageUrl: widget.brandMedia.brand.logo,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8.w),
            DText(
              widget.brandMedia.brand.name,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget postMedia() {
    if (widget.brandMedia.mediaItems.length > 1) {
      return Column(
        children: [
          SizedBox(height: 8.h),
          Stack(
            children: [
              CarouselSlider.builder(
                itemCount: widget.brandMedia.mediaItems.length,
                itemBuilder: (context, index, realIndex) {
                  final mediaItems = widget.brandMedia.mediaItems[index];
                  if (mediaItems.itemType == "photo") {
                    return DazzifyCachedNetworkImage(
                      width: context.screenWidth,
                      imageUrl: widget.brandMedia.mediaItems[index].itemUrl,
                      fit: BoxFit.cover,
                    );
                  } else {
                    _initializeVideoController(index);
                    if (_chewieControllers[index] != null &&
                        _videoControllers[index]!.value.isInitialized) {
                      return VisibilityDetector(
                        onVisibilityChanged: (visibility) {
                          if (visibility.visibleFraction > 0.0) {
                            _videoControllers[index]!.play();
                          } else {
                            _videoControllers[index]!.pause();
                          }
                        },
                        key: ValueKey<String>(mediaItems.itemUrl),
                        child: Chewie(
                          controller: _chewieControllers[index]!,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                },
                options: CarouselOptions(
                  height: 250.h,
                  viewportFraction: 1,
                  autoPlay: false,
                  aspectRatio: 1,
                  autoPlayCurve: Curves.ease,
                  enlargeCenterPage: false,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    _indicatorIndex.value = index;
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _indicatorIndex,
                builder: (context, activeIndex, child) => PositionedDirectional(
                  end: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8).r,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16).r,
                    ),
                    child: DText(
                      "${_indicatorIndex.value + 1} / ${widget.brandMedia.mediaItems.length}",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ValueListenableBuilder(
            valueListenable: _indicatorIndex,
            builder: (context, activeIndex, child) => AnimatedIndicator(
              dotWidth: 5.r,
              dotHeight: 5.r,
              currentIndex: activeIndex,
              selectedColor: context.colorScheme.primary,
              unSelectedColor: ColorsManager.indicatorInactiveColor,
              axisDirection: Axis.horizontal,
              dotsCount: widget.brandMedia.mediaItems.length,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 8.h),
          AspectRatio(
            // aspectRatio: 1,
            aspectRatio: .7,

            child: DazzifyCachedNetworkImage(
              width: context.screenWidth,
              imageUrl: widget.brandMedia.mediaItems[0].itemUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      );
    }
  }

  Widget postButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          FavoriteIconButton(
            hasBackGround: false,
            iconSize: 24.r,
            unFavoriteColor: context.colorScheme.onSurfaceVariant,
            favoriteColor: context.colorScheme.error,
            onFavoriteTap: widget.onLikeTap,
            isFavorite: widget.isLiked,
          ),
          SizedBox(width: 4.w),
          IconButton(
            onPressed: widget.onCommentTap,
            icon: Icon(
              SolarIconsOutline.chatRound,
              size: 24.r,
            ),
          ),
          SizedBox(width: 4.w),
          IconButton(
            onPressed: widget.onSendServiceTap,
            icon: Icon(
              SolarIconsOutline.plain,
              size: 24.r,
            ),
          ),
          const Spacer(),
          DText(
            TimeManager.formatDateTime(widget.brandMedia.createdAt),
            style: context.textTheme.labelMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget likesAndCaption() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 16,
        left: 16,
        right: 16,
      ).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.brandMedia.likesCount != null)
            DText(
              '${widget.brandMedia.likesCount} ${widget.brandMedia.likesCount == 1 ? context.tr.like : context.tr.likes}',
              style: context.textTheme.labelMedium,
            ),
          SizedBox(height: 6.h),
          AnimatedReadMoreText(
            text: widget.brandMedia.caption,
            textStyle: context.textTheme.labelMedium,
            linkStyle: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.primary,
            ),
            trimLines: 2,
            moreText: context.tr.more,
            lessText: context.tr.less,
            animationDuration: const Duration(milliseconds: 500),
            animationCurve: Curves.easeInOut,
          ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    for (var chewieController in _chewieControllers) {
      chewieController?.dispose();
    }
    super.dispose();
  }
}
