import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/data/models/comments/comment_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/widgets/comment_item.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_dialog.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/media_comments_sheet/components/comment_or_reply_edit_dialog.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/settings/theme/colors_scheme_manager.dart';

class RepliesPage extends StatefulWidget {
  const RepliesPage({
    required this.onBackTab,
    required this.media,
    super.key,
  });

  final MediaModel media;
  final void Function() onBackTab;

  @override
  State<RepliesPage> createState() => _RepliesPageState();
}

class _RepliesPageState extends State<RepliesPage> {
  late final CommentsBloc _commentsBloc;
  late final UserCubit _userCubit;
  late final ScrollController _scrollController;
  late final TextEditingController _replyController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _commentsBloc = context.read<CommentsBloc>();
    _userCubit = context.read<UserCubit>();
    _replyController = TextEditingController();
    _scrollController = ScrollController();
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocConsumer<CommentsBloc, CommentsState>(
            listenWhen: (previous, current) =>
                previous.addCommentState != current.addCommentState,
            listener: (context, state) {
              if (state.addCommentState == UiState.success) {
                Future.delayed(
                  const Duration(milliseconds: 500),
                  _scrollToEnd,
                );
              }
            },
            builder: (context, state) {
              CommentModel parentComment =
                  state.commentsList[state.selectedParentIndex];

              List<CommentModel> replies = parentComment.replies;

              return ClipRRect(
                child: DazzifyOverlayLoading(
                  isLoading: state.addCommentState == UiState.loading ||
                      state.deleteCommentState == UiState.loading,
                  blurXy: 5,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 45.h,
                        child: Stack(
                          children: [
                            Center(
                              child: DText(
                                context.tr.replies,
                                style: context.textTheme.titleMedium,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: BackButton(onPressed: () {
                                widget.onBackTab();
                              }),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: context.screenWidth,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 15.h),
                      CommentItem(
                        comment: parentComment,
                        isEdited: parentComment.editedAt != '',
                        onFavoriteTap: () {
                          _commentsBloc.add(
                            AddOrRemoveCommentLikeEvent(
                              commentId: parentComment.id,
                            ),
                          );
                        },
                        hasReplies: false,
                        type: CommentType.parentComment,
                        isFavorite: state.commentLikesIds.contains(
                          parentComment.id,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: replies.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 25.h),
                          itemBuilder: (context, index) {
                            final reply = replies[index];
                            var commentItem = CommentItem(
                              comment: reply,
                              type: CommentType.replyComment,
                              hasReplies: false,
                              isFavorite: state.commentLikesIds.contains(
                                reply.id,
                              ),
                              isEdited: reply.editedAt != '',
                              onEditTab: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BlocProvider.value(
                                      value: _commentsBloc,
                                      child: CommentOrReplyEditDialog(
                                          commentsBloc: _commentsBloc,
                                          originalContent: reply.content,
                                          commentId: reply.id,
                                          parentCommentId: parentComment.id,
                                          onEditTab:
                                              (String updatedContent) async {
                                            if (reply.content !=
                                                updatedContent) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              _commentsBloc.add(
                                                UpdateReplyEvent(
                                                  replyId: reply.id,
                                                  updatedContent:
                                                      updatedContent,
                                                ),
                                              );

                                              context.maybePop();
                                            }
                                          }),
                                    );
                                  },
                                );
                              },
                              onDeleteTab: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BlocProvider.value(
                                      value: _commentsBloc,
                                      child: DazzifyDialog(
                                        message: context.tr.deleteComment,
                                        buttonTitle: context.tr.yes,
                                        onTap: () async {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();

                                          _commentsBloc.add(DeleteReplyEvent(
                                            media: widget.media,
                                            replyId: reply.id,
                                          ));

                                          context.maybePop();
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              onFavoriteTap: () {
                                _commentsBloc.add(
                                  AddOrRemoveReplyLikeEvent(
                                    replyId: reply.id,
                                  ),
                                );
                              },
                            );
                            return commentItem;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: 60.h,
          width: context.screenWidth,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: ColorsSchemeManager.light.outline,
                blurRadius: 10.r,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    bottom: 11.r,
                    top: 11.r,
                    start: 16.r,
                    end: 8.r,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100).r,
                    child: DazzifyCachedNetworkImage(
                      imageUrl: _userCubit.state.userModel.picture ?? '',
                      width: 38.r,
                      height: 38.r,
                    ),
                  ),
                ),
                BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    return Expanded(
                      child: DazzifyTextFormField(
                        controller: _replyController,
                        textInputType: TextInputType.text,
                        autoValidationMode: AutovalidateMode.disabled,
                        borderSide: BorderSide.none,
                        maxLength: 200,
                        hintText: context.tr.commentsTextFieldHint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                      ),
                    );
                  },
                ),
                SizedBox(width: 10.w),
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      _commentsBloc.add(AddReplyEvent(
                        replyContent: _replyController.text,
                        media: widget.media,
                      ));
                      _replyController.clear();
                    }
                  },
                  icon: Icon(
                    SolarIconsBold.plain,
                    color: context.colorScheme.primary,
                    size: 25.r,
                  ),
                ),
                SizedBox(width: 5.w),
              ],
            ),
          ),
        )
      ],
    );
  }
}
