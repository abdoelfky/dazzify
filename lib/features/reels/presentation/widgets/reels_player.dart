import 'package:dazzify/core/injection/injection.dart';
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

  const ReelPlayer({
    super.key,
    required this.reel,
    this.onPageChange,
    required this.onLikeTap,
    required this.videoUrl,
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _showPlayIcon = ValueNotifier(false);
    _hasControllerInitialized = ValueNotifier(false);
    _hasTheUserTappedPause = ValueNotifier(false);
    _hasTheUserOpenedComments = ValueNotifier(false);
    _initReelsPlayer();
    context.read<ReelsBloc>().add(
          AddViewForReelEvent(
            reelId: widget.reel.id,
          ),
        );
  }

  Future<void> _initReelsPlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        _controller.addListener(_videoPlayerListener);
        _controller.addListener(_videoPlaybackListener);
      });
    _hasControllerInitialized.value = true;
  }

  void _videoPlayerListener() {
    if (_controller.value.position >= _controller.value.duration) {
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
            child: Stack(
              children: [
                Center(
                  child: VisibilityDetector(
                    key: ValueKey<String>(widget.videoUrl),
                    onVisibilityChanged: (visibility) {
                      if (visibility.visibleFraction > 0.0 &&
                          !_hasTheUserTappedPause.value &&
                          !_hasTheUserOpenedComments.value) {
                        _controller.play();
                      } else {
                        _controller.pause();
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: 8 / 16.5,
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
                      }else {
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
    super.dispose();
    _controller.dispose();
    _hasControllerInitialized.dispose();
    _hasTheUserOpenedComments.dispose();
    _hasTheUserTappedPause.dispose();
    _showPlayIcon.dispose();
  }
}
