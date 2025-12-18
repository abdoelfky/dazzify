import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/reels/logic/reels_bloc.dart';
import 'package:dazzify/features/reels/presentation/widgets/reels_player.dart';
import 'package:dazzify/features/reels/presentation/widgets/video_preloader.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/animated_filter_button.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late final PageController _pageController;
  late final LikesCubit likesCubit;
  late final ReelsBloc reelsBloc;
  late final VideoPreloader _videoPreloader;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0)..addListener(_onScroll);
    likesCubit = context.read<LikesCubit>();
    reelsBloc = context.read<ReelsBloc>();
    _videoPreloader = VideoPreloader(maxPreloadCount: 2);
    reelsBloc.add(const GetReelsEvent());

    super.initState();
  }

  void _onScroll() async {
    final maxScroll = _pageController.position.maxScrollExtent;
    final currentScroll = _pageController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      reelsBloc.add(const GetReelsEvent());
    }

    // Track current page and preload next videos
    if (_pageController.hasClients) {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        _currentPage = page;
        _preloadNextVideos();
      }
    }
  }

  /// Preload the next 2 videos and dispose old ones
  void _preloadNextVideos() {
    final state = reelsBloc.state;
    if (state.reels.isEmpty) return;

    // Preload next 2 videos
    for (int i = 1; i <= 2; i++) {
      final nextIndex = _currentPage + i;
      if (nextIndex < state.reels.length) {
        final videoUrl = state.reels[nextIndex].mediaItems[0].itemUrl;
        if (!_videoPreloader.isPreloaded(videoUrl)) {
          _videoPreloader.preloadVideo(videoUrl);
        }
      }
    }

    // Dispose videos that are more than 2 positions behind
    for (int i = 0; i < _currentPage - 2; i++) {
      if (i >= 0 && i < state.reels.length) {
        final videoUrl = state.reels[i].mediaItems[0].itemUrl;
        _videoPreloader.disposeController(videoUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelsBloc, ReelsState>(
      buildWhen: (previous, current) => previous.reels != current.reels,
      builder: (context, state) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            if (didPop) {
              _logger.logEvent(event: AppEvents.reelsClickBack);
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                if (state.reels.isEmpty && state.reelsState == UiState.success)
                  Center(
                    child: EmptyDataWidget(
                      message: context.tr.noReels,
                    ),
                  )
                else
                  Positioned.fill(
                    top: 0,
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      itemCount: state.hasReelsReachedMax
                          ? state.reels.length
                          : state.reels.length + 1,
                      onPageChanged: (index) {
                        _currentPage = index;
                        _preloadNextVideos();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        switch (state.reelsState) {
                          case UiState.initial:
                          case UiState.loading:
                            return const Center(child: LoadingAnimation());
                          case UiState.failure:
                            return ErrorDataWidget(
                              errorDataType: DazzifyErrorDataType.screen,
                              message: state.errorMessage,
                              onTap: () {
                                reelsBloc.add(const GetReelsEvent());
                              },
                            );
                          case UiState.success:
                            if (index >= state.reels.length) {
                              if (state.hasReelsReachedMax &&
                                  state.reels.isNotEmpty) {
                                return const SizedBox.shrink();
                              } else if (state.reels.isEmpty) {
                                return Center(
                                  child: EmptyDataWidget(
                                    message: context.tr.noReels,
                                  ),
                                );
                              } else {
                                return const LoadingAnimation();
                              }
                            } else {
                              final currentReel = state.reels[index];
                              final videoUrl =
                                  currentReel.mediaItems[0].itemUrl;

                              // Preload next videos when building current item
                              if (index == _currentPage) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _preloadNextVideos();
                                });
                              }

                              return BlocProvider(
                                create: (context) => getIt<CommentsBloc>(),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30).r,
                                  child: ReelPlayer(
                                    reel: currentReel,
                                    videoUrl: videoUrl,
                                    preloadedController:
                                        _videoPreloader.getController(videoUrl),
                                    onLikeTap: () => likesCubit.addOrRemoveLike(
                                        mediaId: currentReel.id),
                                    onPageChange: () {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                        }
                      },
                    ),
                  ),
                PositionedDirectional(
                  top: 40.h,
                  end: 10.w,
                  child: AnimatedFilterButton(
                    onItemTap: (int index) {
                      _logger.logEvent(
                        event: AppEvents.reelsClickFilter,
                        mainCategoryId: mainCategories[index].id,
                      );
                      reelsBloc.add(
                        FilterReelsByCategories(
                          mainCategoryId: mainCategories[index].id,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onScroll)
      ..dispose();
    _videoPreloader.disposeAll();
    super.dispose();
  }
}
