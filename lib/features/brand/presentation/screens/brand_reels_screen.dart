import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/reels/logic/reels_bloc.dart';
import 'package:dazzify/features/reels/presentation/widgets/reels_player.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.index);
    likesCubit = context.read<LikesCubit>();
    reelsBloc = getIt<ReelsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: widget.vendorBloc.state.reels.length,
            itemBuilder: (context, index) {
              final currentReel = widget.vendorBloc.state.reels[index];
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
                  // isLiked: likesCubit.state.likesIds.contains(currentReel.id),
                  reel: currentReel,
                  videoUrl: currentReel.mediaItems[0].itemUrl,
                  onLikeTap: () =>
                      likesCubit.addOrRemoveLike(mediaId: currentReel.id),
                ),
              );
            },
          ),
          PositionedDirectional(
            top: 25.h,
            start: 6.w,
            child: const DazzifyAppBar(isLeading: true),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
