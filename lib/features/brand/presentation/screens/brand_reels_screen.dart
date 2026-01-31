import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/reels/logic/reels_bloc.dart';
import 'package:dazzify/features/reels/presentation/widgets/reels_player.dart';
import 'package:dazzify/features/reels/presentation/widgets/video_preloader.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class BrandReelsScreen extends StatefulWidget implements AutoRouteWrapper {
  final int index;
  final BrandBloc vendorBloc;

  const BrandReelsScreen({
    super.key,
    required this.index,
    required this.vendorBloc,
  });

  @override
  State<BrandReelsScreen> createState() => _VendorReelsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: vendorBloc, child: this);
  }
}

class _VendorReelsScreenState extends State<BrandReelsScreen> {
  late final PageController _controller;
  late final LikesCubit likesCubit;
  late final ReelsBloc reelsBloc;
  late final VideoPreloader _videoPreloader;
  late final BrandBloc brandBloc;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.index)
      ..addListener(_onScroll);
    _currentPage = widget.index;
    likesCubit = context.read<LikesCubit>();
    reelsBloc = getIt<ReelsBloc>();
    brandBloc = widget.vendorBloc;
    _videoPreloader = VideoPreloader(maxPreloadCount: 3);
    
    // Preload initial videos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadNextVideos();
    });
  }

  void _onScroll() async {
    if (!_controller.hasClients) return;
    
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    
    // Load more reels when reaching 80% of scroll
    if (currentScroll >= (maxScroll * 0.8)) {
      final state = brandBloc.state;
      if (!state.hasReelsReachedMax && state.reelsState != UiState.loading) {
        brandBloc.add(GetBrandReelsEvent(state.brandDetails.id));
      }
    }
    
    // Track current page and preload next videos
    final page = _controller.page?.round() ?? 0;
    if (page != _currentPage) {
      _currentPage = page;
      _preloadNextVideos();
    }
  }

  /// Preload the next 3 videos and dispose old ones
  void _preloadNextVideos() {
    final state = brandBloc.state;
    if (state.reels.isEmpty) return;
    
    // Preload next 3 videos
    for (int i = 1; i <= 3; i++) {
      final nextIndex = _currentPage + i;
      if (nextIndex < state.reels.length) {
        final videoUrl = state.reels[nextIndex].mediaItems[0].itemUrl;
        if (!_videoPreloader.isPreloaded(videoUrl)) {
          _videoPreloader.preloadVideo(videoUrl);
        }
      }
    }
    
    // Dispose videos that are more than 3 positions behind
    for (int i = 0; i < _currentPage - 3; i++) {
      if (i >= 0 && i < state.reels.length) {
        final videoUrl = state.reels[i].mediaItems[0].itemUrl;
        _videoPreloader.disposeController(videoUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandBloc, BrandState>(
      bloc: brandBloc,
      buildWhen: (previous, current) => 
          previous.reels != current.reels || 
          previous.reelsState != current.reelsState ||
          previous.hasReelsReachedMax != current.hasReelsReachedMax,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              if (state.reels.isEmpty && state.reelsState == UiState.success)
                Center(
                  child: EmptyDataWidget(
                    message: context.tr.emptyVendorReels,
                  ),
                )
              else
                PageView.builder(
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  itemCount: state.hasReelsReachedMax
                      ? state.reels.length
                      : state.reels.length + 1,
                  onPageChanged: (index) {
                    _currentPage = index;
                    _preloadNextVideos();
                  },
                  itemBuilder: (context, index) {
                    if (index >= state.reels.length) {
                      if (state.hasReelsReachedMax && state.reels.isNotEmpty) {
                        return const SizedBox.shrink();
                      } else if (state.reels.isEmpty) {
                        return Center(
                          child: EmptyDataWidget(
                            message: context.tr.emptyVendorReels,
                          ),
                        );
                      } else {
                        return const Center(child: LoadingAnimation());
                      }
                    }
                    
                    final currentReel = state.reels[index];
                    final videoUrl = currentReel.mediaItems[0].itemUrl;
                    
                    // Preload next videos when building current item
                    if (index == _currentPage) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _preloadNextVideos();
                      });
                    }
                    
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => getIt<CommentsBloc>()
                            ..add(const GetCommentLikesIdsEvent()),
                        ),
                        BlocProvider(
                          create: (context) => reelsBloc,
                        ),
                      ],
                      child: ReelPlayer(
                        reel: currentReel,
                        videoUrl: videoUrl,
                        preloadedController: _videoPreloader.getController(videoUrl),
                        onLikeTap: () =>
                            likesCubit.addOrRemoveLike(mediaId: currentReel.id),
                        onPageChange: () {
                          if (_controller.hasClients) {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              PositionedDirectional(
                top: 30.h,
                start: 6.w,
                child: const DazzifyAppBar(isLeading: true),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    _videoPreloader.disposeAll();
    super.dispose();
  }
}
