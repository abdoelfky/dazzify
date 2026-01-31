import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/features/home/logic/search/search_bloc.dart';
import 'package:dazzify/features/reels/logic/reels_bloc.dart';
import 'package:dazzify/features/reels/presentation/widgets/reels_player.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ReelViewerScreen extends StatefulWidget implements AutoRouteWrapper {
  final MediaModel reel;

  const ReelViewerScreen({super.key, required this.reel});

  @override
  State<ReelViewerScreen> createState() => _ReelViewerScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CommentsBloc>(),
      child: this,
    );
  }
}

class _ReelViewerScreenState extends State<ReelViewerScreen> {
  late final SearchBloc searchBloc;
  late final ReelsBloc reelsBloc;
  late final LikesCubit likesCubit;

  @override
  void initState() {
    super.initState();
    searchBloc = context.read<SearchBloc>();
    reelsBloc = getIt<ReelsBloc>();
    likesCubit = context.read<LikesCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Handle back button if needed
      },
      child: Scaffold(
      body: Stack(
        children: [
          BlocProvider.value(
            value: reelsBloc,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30).r,
              child: ReelPlayer(
                reel: widget.reel,
                videoUrl: widget.reel.mediaItems[0].itemUrl,
                onLikeTap: () {
                  likesCubit.addOrRemoveLike(
                    mediaId: widget.reel.id,
                  );
                },
              ),
            ),
          ),
          PositionedDirectional(
            top: 30.h,
            start: 8.w,
            child: const DazzifyAppBar(isLeading: true),
          ),
        ],
      ),
      ),
    );
  }
}
