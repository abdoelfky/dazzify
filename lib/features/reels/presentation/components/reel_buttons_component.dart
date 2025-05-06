import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/comments_closed_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/media_comments_sheet/media_comment_sheet.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:video_player/video_player.dart';

class ReelsButtonComponent extends StatefulWidget {
  final MediaModel reel;
  final VideoPlayerController controller;
  final ValueNotifier<bool> hasTheUserTappedPause;
  final ValueNotifier<bool> hasTheUserOpenedComments;
  final void Function() onLikeTap;
  final void Function() onChatTap;

  const ReelsButtonComponent({
    super.key,
    required this.reel,
    required this.controller,
    required this.hasTheUserTappedPause,
    required this.onLikeTap,
    required this.onChatTap,
    required this.hasTheUserOpenedComments,
  });

  @override
  State<ReelsButtonComponent> createState() => _ReelsButtonComponentState();
}

class _ReelsButtonComponentState extends State<ReelsButtonComponent> {
  late final LikesCubit _likesCubit;
  late int _likesCount = widget.reel.likesCount ?? 0;
  late int _commentsCount = widget.reel.commentsCount ?? 0;
  late bool _isLiked;

  @override
  void initState() {
    _likesCubit = context.read<LikesCubit>();
    _isLiked = _likesCubit.state.likesIds.contains(widget.reel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BlocConsumer<LikesCubit, LikesState>(
          listener: (context, state) {
            // final currentMediaId = _likesCubit.currentMediaId;
            //
            // if (currentMediaId != widget.reel.id) return;
            //
            // if (state.addLikeState == UiState.loading) {
            //   _likesCount++;
            // } else if (state.removeLikeState == UiState.loading) {
            //   _likesCount--;
            // }
            // if (state.addLikeState == UiState.loading) {
            //   if (widget.reel.likesCount != null) {
            //     _likesCount++;
            //   }
            // } else if (state.removeLikeState == UiState.loading &&
            //     _likesCubit.currentMediaId == widget.reel.id) {
            //   if (widget.reel.likesCount != null) {
            //     _likesCount--;
            //   }
            // }
            // if (state.addLikeState == UiState.loading &&
            //     _likesCubit.currentMediaId == widget.reel.id) {
            //   _likesCount++;
            //
            //   if (widget.reel.likesCount != null) {
            //     widget.reel.likesCount! + 1;
            //
            //   }
            // } else if (state.removeLikeState == UiState.loading &&
            //     _likesCubit.currentMediaId == widget.reel.id) {
            //   _likesCount--;
            //
            //   if (widget.reel.likesCount != null) {
            //     widget.reel.likesCount! - 1;
            //
            //   }
            // }
          },
          builder: (context, state) {
            return Row(
              children: [
                if (widget.reel.likesCount != null)
                  DText(
                    _likesCount.toString(),
                    // state.addLikeState.toString(),
                    // widget.reel.likesCount.toString(),
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                SizedBox(width: 2.w),
                FavoriteIconButton(
                  hasBackGround: false,
                  iconSize: 28.r,
                  unFavoriteColor: context.colorScheme.onPrimary,
                  favoriteColor: context.colorScheme.error,
                  onFavoriteTap: () {
                    setState(() {
                      if (_isLiked) {
                        _likesCount--;
                      } else {
                        _likesCount++;
                      }
                      _isLiked = !_isLiked;
                    });

                    widget.onLikeTap(); // هذا يستدعي cubit
                  },
                  isFavorite: state.likesIds.contains(widget.reel.id),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 25.h),
        BlocConsumer<CommentsBloc, CommentsState>(
          // listenWhen: (previous, current) =>
          //     previous.addCommentState != current.addCommentState ||
          //     previous.deleteCommentState != current.deleteCommentState,
          listener: (context, state) {
            _commentsCount = state.commentsList.fold<int>(
              0,
              (total, comment) => total + 1 + (comment.replies.length),
            );

            // if (state.addCommentState == UiState.loading) {
            //   state.commentsList.length;
            //   _commentsCount=state.commentsList.length;
            // } else if (state.deleteCommentState == UiState.loading) {
            //   _commentsCount=state.commentsList.length;
            // }
          },
          builder: (context, state) {
            return Row(
              children: [
                if (widget.reel.commentsCount != null)
                  DText(
                    _commentsCount.toString(),
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                SizedBox(width: 2.w),
                ValueListenableBuilder(
                  valueListenable: widget.hasTheUserTappedPause,
                  builder: (context, hasPauseButtonTapped, child) => IconButton(
                    onPressed: () {
                      if (widget.controller.value.isPlaying) {
                        widget.controller.pause();
                      }
                      widget.hasTheUserOpenedComments.value = true;
                      final commentsBloc = context.read<CommentsBloc>();
                      final userCubit = context.read<UserCubit>();
                      if (AuthLocalDatasourceImpl().checkGuestMode()) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: false,
                          builder: (context) {
                            return GuestModeBottomSheet();
                          },
                        );
                      } else if (widget.reel.commentsCount == null) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: false,
                          builder: (context) {
                            return CommentsClosedBottomSheet();
                          },
                        );
                      } else {
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          routeSettings:
                              const RouteSettings(name: "ReelsCommentSheet"),
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: commentsBloc),
                              BlocProvider.value(value: userCubit),
                            ],
                            child: MediaCommentsSheet(media: widget.reel),
                          ),
                        ).whenComplete(() {
                          if (hasPauseButtonTapped == false) {
                            widget.controller.play();
                          }
                          widget.hasTheUserOpenedComments.value = false;
                        });
                      }
                    },
                    icon: Icon(
                      SolarIconsOutline.chatRound,
                      size: 28.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 25.h),
        IconButton(
          onPressed: () {
            widget.onChatTap();
          },
          icon: Icon(
            SolarIconsOutline.plain,
            size: 26.r,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
