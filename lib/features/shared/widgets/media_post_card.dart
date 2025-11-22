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
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/animated_read_more_text.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
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
  late int _likesCount;
  late final LikesCubit _likesCubit;
  late ValueNotifier<bool> _showHeart;

  @override
  void initState() {
    _likesCount = widget.brandMedia.likesCount ?? 0;
    _videoControllers = List<VideoPlayerController?>.filled(
        widget.brandMedia.mediaItems.length, null);
    _chewieControllers = List<ChewieController?>.filled(
        widget.brandMedia.mediaItems.length, null);
    _indicatorIndex = ValueNotifier<int>(0);
    _likesCubit = context.read<LikesCubit>();
    _showHeart = ValueNotifier(false);

    super.initState();
  }

  Future<void> _initializeVideoController(int index) async {
    if (_videoControllers[index] == null) {
      final videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.brandMedia.mediaItems[index].itemUrl),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: false,
        ),
      );
      
      // Initialize immediately - don't wait for full download
      await videoController.initialize();
      
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: true,
        looping: true,
        showControls: false,
        aspectRatio: _parseAspectRatio(widget.brandMedia.aspectRatio) ?? 4 / 3,
        // Allow playback to start with progressive loading
        startAt: Duration.zero,
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
        
        // Auto-play first video when post comes into view
        if (visibilityInfo.visibleFraction > 0.5) {
          final firstItem = widget.brandMedia.mediaItems[_indicatorIndex.value];
          if (firstItem.itemType == "video" && 
              _videoControllers[_indicatorIndex.value] != null &&
              _videoControllers[_indicatorIndex.value]!.value.isInitialized) {
            _videoControllers[_indicatorIndex.value]!.play();
          }
        } else {
          // Pause all videos when post goes out of view
          for (int i = 0; i < _videoControllers.length; i++) {
            if (_videoControllers[i] != null) {
              _videoControllers[i]!.pause();
            }
          }
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
                GestureDetector(
                    onDoubleTap: () {
                      if (AuthLocalDatasourceImpl().checkGuestMode()) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: false,
                          builder: (context) {
                            return GuestModeBottomSheet();
                          },
                        );
                      } else {
                        if (!widget.isLiked) widget.onLikeTap();
                        _showHeart.value = true;
                        Future.delayed(const Duration(milliseconds: 700), () {
                          _showHeart.value = false;
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        postMedia(),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: _showHeart,
                            builder: (context, isVisible, _) {
                              return AnimatedOpacity(
                                opacity: isVisible ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red.withOpacity(0.85),
                                  size: 90,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.5),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )),
                postButtons(),
                BlocListener<LikesCubit, LikesState>(
                  listener: (context, state) {
                    final currentMediaId = _likesCubit.currentMediaId;

                    if (currentMediaId != widget.brandMedia.id) return;

                    if (state.addLikeState == UiState.loading) {
                      _likesCount++;
                    } else if (state.removeLikeState == UiState.loading) {
                      _likesCount--;
                    }
                  },
                  child: likesAndCaption(),
                )
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
                    } else {
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
            Row(
              children: [
                DText(
                  truncateText(widget.brandMedia.brand.name, 25),
                  style: context.textTheme.bodyMedium,
                ),
                const SizedBox(width: 2),
                if (widget.brandMedia.brand.verified)
                  Icon(
                    SolarIconsBold.verifiedCheck,
                    color: context.colorScheme.primary,
                    size: 15.r,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget postMedia() {
    if (widget.brandMedia.mediaItems.length > 1) {
      final aspectRatio = _parseAspectRatio(widget.brandMedia.aspectRatio) ?? 0.7;
      final carouselHeight = context.screenWidth / aspectRatio;

      return Column(
        children: [
          SizedBox(height: 8.h),
          Stack(
            children: [
              AspectRatio(
                aspectRatio:
                    _parseAspectRatio(widget.brandMedia.aspectRatio) ?? 0.7,
                child: CarouselSlider.builder(
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
                            if (visibility.visibleFraction > 0.0 && _indicatorIndex.value == index) {
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
                        return Shimmer.fromColors(
                          baseColor: context.isDarkTheme
                              ? ColorsManager.baseShimmerDark
                              : ColorsManager.baseShimmerLight,
                          highlightColor: context.isDarkTheme
                              ? ColorsManager.highlightShimmerDark
                              : ColorsManager.highlightShimmerLight,
                          child: Container(
                            width: context.screenWidth,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        );
                      }
                    }
                  },
                  options: CarouselOptions(
                    viewportFraction: 1,
                    autoPlay: false,
                    height: carouselHeight,
                    aspectRatio: aspectRatio,

                    autoPlayCurve: Curves.ease,
                    enlargeCenterPage: false,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      // Pause all videos first
                      for (int i = 0; i < _videoControllers.length; i++) {
                        if (_videoControllers[i] != null) {
                          _videoControllers[i]!.pause();
                        }
                      }
                      _indicatorIndex.value = index;
                      // Auto-play the current video if it's a video
                      if (widget.brandMedia.mediaItems[index].itemType == "video" &&
                          _videoControllers[index] != null) {
                        _videoControllers[index]!.play();
                      }
                    },
                  ),
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
      // Single media item
      final mediaItem = widget.brandMedia.mediaItems[0];
      if (mediaItem.itemType == "photo") {
        return Column(
          children: [
            SizedBox(height: 8.h),
            AspectRatio(
              aspectRatio:
                  _parseAspectRatio(widget.brandMedia.aspectRatio) ?? 0.7,
              child: DazzifyCachedNetworkImage(
                width: context.screenWidth,
                imageUrl: mediaItem.itemUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        );
      } else {
        // Single video
        _initializeVideoController(0);
        return Column(
          children: [
            SizedBox(height: 8.h),
            if (_chewieControllers[0] != null &&
                _videoControllers[0]!.value.isInitialized)
              VisibilityDetector(
                onVisibilityChanged: (visibility) {
                  if (visibility.visibleFraction > 0.5) {
                    _videoControllers[0]!.play();
                  } else {
                    _videoControllers[0]!.pause();
                  }
                },
                key: ValueKey<String>(mediaItem.itemUrl),
                child: AspectRatio(
                  aspectRatio:
                      _parseAspectRatio(widget.brandMedia.aspectRatio) ?? 0.7,
                  child: Chewie(
                    controller: _chewieControllers[0]!,
                  ),
                ),
              )
            else
              Shimmer.fromColors(
                baseColor: context.isDarkTheme
                    ? ColorsManager.baseShimmerDark
                    : ColorsManager.baseShimmerLight,
                highlightColor: context.isDarkTheme
                    ? ColorsManager.highlightShimmerDark
                    : ColorsManager.highlightShimmerLight,
                child: AspectRatio(
                  aspectRatio:
                      _parseAspectRatio(widget.brandMedia.aspectRatio) ?? 0.7,
                  child: Container(
                    width: context.screenWidth,
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(height: 8.h),
          ],
        );
      }
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
              '$_likesCount ${_likesCount == 1 ? context.tr.like : context.tr.likes}',
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
    _showHeart.dispose();

    super.dispose();
  }
}

double? _parseAspectRatio(String? ratioString) {
  if (ratioString == null || !ratioString.contains(':')) return null;
  try {
    final parts = ratioString.split(':');
    final width = double.parse(parts[0]);
    final height = double.parse(parts[1]);
    if (height == 0) return null;
    return width / height;
  } catch (_) {
    return null;
  }
}
