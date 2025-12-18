import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/brand/presentation/bottom_sheets/chat_branches_sheet.dart';
import 'package:dazzify/features/reels/logic/reels_bloc.dart';
import 'package:dazzify/features/reels/presentation/components/reel_buttons_component.dart';
import 'package:dazzify/features/reels/presentation/components/reel_info_component.dart';
import 'package:dazzify/features/reels/presentation/widgets/play_button.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelPlayer extends StatefulWidget {
  final MediaModel reel;
  final String videoUrl;
  final VoidCallback? onPageChange;
  final void Function() onLikeTap;
  final VideoPlayerController? preloadedController;

  const ReelPlayer({
    super.key,
    required this.reel,
    this.onPageChange,
    required this.onLikeTap,
    required this.videoUrl,
    this.preloadedController,
  });

  @override
  State<ReelPlayer> createState() => _ReelPlayerState();
}

class _ReelPlayerState extends State<ReelPlayer>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final VideoPlayerController _controller;
  late final ValueNotifier<bool> _showPlayIcon;
  late final ValueNotifier<bool> _hasControllerInitialized;
  late final ValueNotifier<bool> _hasTheUserTappedPause;
  late final ValueNotifier<bool> _hasTheUserOpenedComments;
  late final ValueNotifier<bool> _showHeart;
  bool _isUsingPreloadedController = false;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();
  DateTime? _watchStartTime;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _showPlayIcon = ValueNotifier(false);
    _hasControllerInitialized = ValueNotifier(false);
    _hasTheUserTappedPause = ValueNotifier(false);
    _hasTheUserOpenedComments = ValueNotifier(false);
    _showHeart = ValueNotifier(false);
    _initReelsPlayer();
    context.read<ReelsBloc>().add(
          AddViewForReelEvent(
            reelId: widget.reel.id,
          ),
        );
  }

  Future<void> _initReelsPlayer() async {
    // Use preloaded controller if available
    if (widget.preloadedController != null &&
        widget.preloadedController!.value.isInitialized) {
      _controller = widget.preloadedController!;
      _isUsingPreloadedController = true;
      debugPrint('✅ Using preloaded controller for: ${widget.videoUrl}');
    } else {
      // Create new controller if no preloaded one available
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: false,
        ),
      );
      _isUsingPreloadedController = false;

      // Initialize with progressive loading - ready to play when visible
      await _controller.initialize();
      debugPrint('⚠️ Creating new controller for: ${widget.videoUrl}');
    }

    _controller.addListener(_videoPlayerListener);
    _controller.addListener(_videoPlaybackListener);
    _hasControllerInitialized.value = true;

    // Don't auto-play - let VisibilityDetector control playback
  }

  void _videoPlayerListener() {
    // Only trigger page change if video actually played and finished
    if (_controller.value.isInitialized &&
        _controller.value.duration.inMilliseconds > 0 &&
        _controller.value.position >= _controller.value.duration) {
      _controller.seekTo(Duration.zero);
      widget.onPageChange?.call();
    }
  }

  void _videoPlaybackListener() {
    if (_controller.value.isInitialized) {
      _showPlayIcon.value =
          !_controller.value.isPlaying && !_controller.value.isBuffering;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder(
      valueListenable: _hasControllerInitialized,
      builder: (context, value, child) {
        if (value == true) {
          return GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
                _hasTheUserTappedPause.value = true;
              }
            },
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
                widget.onLikeTap();
                _showHeart.value = true;
                Future.delayed(const Duration(milliseconds: 700), () {
                  _showHeart.value = false;
                });
              }
            },
            child: Stack(
              children: [
                Container(
                  color: Colors.black,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: VisibilityDetector(
                    key: ValueKey<String>(widget.videoUrl),
                    onVisibilityChanged: (visibility) {
                      if (visibility.visibleFraction > 0.8) {
                        // Reset pause state when reel becomes fully visible
                        _hasTheUserTappedPause.value = false;
                        _hasTheUserOpenedComments.value = false;
                        _watchStartTime = DateTime.now();
                        _controller.play();
                      } else if (visibility.visibleFraction < 0.2) {
                        // Log watch time when reel becomes invisible
                        if (_watchStartTime != null) {
                          final watchDuration =
                              DateTime.now().difference(_watchStartTime!);
                          final timeInSeconds = watchDuration.inSeconds;
                          if (timeInSeconds > 0) {
                            _logger.logReelsWatchTime(
                              mediaId: widget.reel.id,
                              timeInSeconds: timeInSeconds,
                            );
                          }
                          _watchStartTime = null;
                        }
                        _controller.pause();
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: _parseAspectRatio(widget.reel.aspectRatio) ??
                          8 / 16.5,
                      // aspectRatio: 8 / 16.5,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  top: 0,
                  bottom: 0,
                  child: ValueListenableBuilder(
                    valueListenable: _showPlayIcon,
                    builder: (context, isPlayButtonShowing, child) =>
                        isPlayButtonShowing
                            ? PlayButton(
                                onPressed: () {
                                  if (_controller.value.isPlaying == false) {
                                    _hasTheUserTappedPause.value = false;
                                    _controller.play();
                                  }
                                },
                              )
                            : const SizedBox.shrink(),
                  ),
                ),
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
                PositionedDirectional(
                  bottom: 50.h,
                  end: 10.w,
                  child: ReelsButtonComponent(
                    reel: widget.reel,
                    onLikeTap: widget.onLikeTap,
                    controller: _controller,
                    hasTheUserTappedPause: _hasTheUserTappedPause,
                    hasTheUserOpenedComments: _hasTheUserOpenedComments,
                    onChatTap: () {
                      final BrandBloc brandBloc = getIt<BrandBloc>();
                      brandBloc.add(
                        GetBrandBranchesEvent(
                          widget.reel.brand.id,
                        ),
                      );
                      if (AuthLocalDatasourceImpl().checkGuestMode()) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: false,
                          builder: (context) {
                            return GuestModeBottomSheet();
                          },
                        );
                      } else {
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          routeSettings: const RouteSettings(
                            name: "BranchesBottomSheet",
                          ),
                          builder: (context) => BlocProvider.value(
                            value: brandBloc,
                            child: ChatBranchesSheet(
                              sheetType: BranchesSheetType.chat,
                              serviceId: widget.reel.serviceId,
                              brand: widget.reel.brand,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                PositionedDirectional(
                  bottom: 30.h,
                  start: 10.w,
                  child: ReelInfoComponent(
                    reel: widget.reel,
                    isWaveAnimating: _showPlayIcon,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const LoadingAnimation();
        }
      },
    );
  }

  @override
  void dispose() {
    // Log watch time when reel is disposed
    if (_watchStartTime != null) {
      final watchDuration = DateTime.now().difference(_watchStartTime!);
      final timeInSeconds = watchDuration.inSeconds;
      if (timeInSeconds > 0) {
        _logger.logReelsWatchTime(
          mediaId: widget.reel.id,
          timeInSeconds: timeInSeconds,
        );
      }
      _watchStartTime = null;
    }
    super.dispose();
    // Only dispose controller if we created it (not preloaded)
    if (!_isUsingPreloadedController) {
      _controller.dispose();
    }
    _hasControllerInitialized.dispose();
    _hasTheUserOpenedComments.dispose();
    _hasTheUserTappedPause.dispose();
    _showPlayIcon.dispose();
    _showHeart.dispose();
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
