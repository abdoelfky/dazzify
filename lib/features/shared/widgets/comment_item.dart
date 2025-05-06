import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/bottom_sheets/report_bottom_sheet.dart';
import 'package:dazzify/features/shared/data/models/comments/comment_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';

class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final bool hasReplies;
  final CommentType type;
  final bool isFavorite;
  final bool isEdited;
  final void Function()? onDeleteTab;
  final void Function()? onReplyTab;
  final void Function()? onEditTab;
  final void Function() onFavoriteTap;

  const CommentItem({
    super.key,
    required this.comment,
    required this.type,
    required this.isFavorite,
    required this.isEdited,
    required this.hasReplies,
    required this.onFavoriteTap,
    this.onReplyTab,
    this.onDeleteTab,
    this.onEditTab,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final GlobalKey<PopupMenuButtonState<int>> _popupMenuKey = GlobalKey();
  late final UserCubit _userCubit;

  @override
  void initState() {
    super.initState();
    _userCubit = context.read<UserCubit>();
  }

  @override
  void dispose() {
    _popupMenuKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onLongPress: () {
            if (widget.type != CommentType.parentComment &&
                widget.comment.author.id == _userCubit.state.userModel.id) {
              _popupMenuKey.currentState?.showButtonMenu();
            }
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Padding(
            padding: widget.type == CommentType.replyComment
                ? EdgeInsetsDirectional.only(
                    top: 16.r,
                    bottom: 16.r,
                    end: 16.r,
                    start: 48.r,
                  )
                : const EdgeInsets.symmetric(horizontal: 16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: DazzifyCachedNetworkImage(
                        imageUrl: widget.comment.author.picture,
                        width: 32.r,
                        height: 32.r,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    SizedBox(
                      width:
                          widget.type == CommentType.replyComment ? 200 : 233.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: widget.type == CommentType.replyComment
                                    ? 80.w
                                    : 110.w,
                                child: Row(
                                  children: [
                                    ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 80.w),
                                        child: IntrinsicWidth(
                                            child: DText(
                                          widget.comment.author.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.bodyMedium,
                                        ))),
                                    if (widget.comment.author.verified)
                                      SizedBox(width: 4.w),
                                    if (widget.comment.author.verified)
                                      Icon(
                                        SolarIconsBold.verifiedCheck,
                                        color: context.colorScheme.primary,
                                        size: 14.r,
                                      ),
                                  ],
                                ),
                              ),
                              DText(
                                TimeManager.extractDayName(
                                    widget.comment.createdAt),
                                style: context.textTheme.labelSmall!.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(
                                width: 50.w,
                                child: widget.isEdited
                                    ? DText(
                                        context.tr.edited,
                                        style: context.textTheme.labelSmall!
                                            .copyWith(
                                          color: context
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              )
                            ],
                          ),
                          SizedBox(height: 4.w),
                          DText(
                            widget.comment.content,
                            maxLines: 10,
                            style: context.textTheme.bodySmall,
                          ),
                          SizedBox(height: 4.w),

                        ],
                      ),
                    ),

                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BlocBuilder<CommentsBloc, CommentsState>(
                          builder: (context, state) {
                            return FavoriteIconButton(
                              favoriteColor: context.colorScheme.error,
                              unFavoriteColor:
                                  context.colorScheme.onSurfaceVariant,
                              iconSize: 20.r,
                              hasBackGround: false,
                              isFavorite: widget.isFavorite,
                              onFavoriteTap: widget.onFavoriteTap,
                            );
                          },
                        ),
                        DText(
                          widget.comment.likesCount.toString(),
                          style: context.textTheme.labelSmall!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.type == CommentType.mainComment)
                  Row(
                    children: [
                      SizedBox(width: 48.w),
                      GestureDetector(
                          onTap: widget.onReplyTab,
                          child: Row(
                            children: [
                              DText(
                                context.tr.reply,
                                style: context.textTheme.labelMedium!.copyWith(
                                    color:
                                        context.colorScheme.onSurfaceVariant),
                              ),
                              if (widget.hasReplies)
                                Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(start: 16.0.w),
                                  child: DText(
                                    context.tr.showReplies,
                                    style: context.textTheme.labelMedium!
                                        .copyWith(
                                            color: context
                                                .colorScheme.onSurfaceVariant),
                                  ),
                                ),
                            ],
                          )),
                      SizedBox(width: 16.w),
                      if (widget.comment.author.id !=
                          context.read<UserCubit>().state.userModel.id)
                        GestureDetector(
                          onTap: () {
                            showReportBottomSheet(
                              context: context,
                              id: widget.comment.id,
                              type: "comment",
                            );
                          },
                          child: DText(
                            context.tr.report,
                            style: context.textTheme.labelMedium!.copyWith(
                                color: context.colorScheme.onSurfaceVariant),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        PositionedDirectional(
            end: 16.w,
            child: PopupMenuButton<int>(
              key: _popupMenuKey,
              constraints: BoxConstraints(
                maxWidth: 150.w,
              ),
              shadowColor: context.colorScheme.outline,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 0,
                  height: 10.h,
                  child: Row(
                    children: [
                      Icon(
                        SolarIconsOutline.trashBinTrash,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      DText(
                        context.tr.deleteComment,
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 1,
                  height: 10.h,
                  child: Row(
                    children: [
                      Icon(
                        SolarIconsOutline.pen,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      DText(
                        context.tr.editComment,
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (int value) {
                if (widget.type != CommentType.parentComment) {
                  value == 0 ? widget.onDeleteTab!() : widget.onEditTab!();
                }
              },
              child: const SizedBox.shrink(),
            ))
      ],
    );
  }
}
