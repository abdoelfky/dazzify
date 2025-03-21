import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/widgets/comment_item.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_dialog.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/media_comments_sheet/components/comment_or_reply_edit_dialog.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/settings/theme/colors_scheme_manager.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({
    required this.media,
    required this.onReplyTab,
    super.key,
  });

  final MediaModel media;
  final Function(int) onReplyTab;

  @override
  State<CommentsPage> createState() => _MainCommentsState();
}

class _MainCommentsState extends State<CommentsPage> {
  late final CommentsBloc _commentsBloc;
  late final UserCubit _userCubit;
  late final ScrollController _scrollController;
  late final TextEditingController _commentController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _commentsBloc = context.read<CommentsBloc>();
    _commentsBloc
      ..add(GetCommentsEvent(mediaId: widget.media.id))
      ..add(const GetCommentLikesIdsEvent());
    _userCubit = context.read<UserCubit>();
    _commentController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _onScroll() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      _commentsBloc.add(GetCommentsEvent(mediaId: widget.media.id));
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
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
                Future.delayed(const Duration(milliseconds: 500), _scrollToEnd);
              }
            },
            builder: (context, state) {
              switch (state.getCommentsState) {
                case UiState.initial:
                case UiState.loading:
                  return const LoadingAnimation();
                case UiState.failure:
                  return ErrorDataWidget(
                    errorDataType: DazzifyErrorDataType.sheet,
                    message: state.errorMessage,
                    onTap: () {
                      _commentsBloc
                          .add(GetCommentsEvent(mediaId: widget.media.id));
                    },
                  );
                case UiState.success:
                  if (state.commentsList.isEmpty) {
                    return EmptyDataWidget(
                      message: context.tr.commentsEmpty,
                    );
                  } else {
                    return ClipRRect(
                      child: DazzifyOverlayLoading(
                        isLoading: state.addCommentState == UiState.loading ||
                            state.deleteCommentState == UiState.loading,
                        blurXy: 5,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 45.h,
                              child: Center(
                                child: DText(
                                  context.tr.comments,
                                  style: context.textTheme.titleMedium,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: context.screenWidth,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(height: 15.h),
                            Expanded(
                              child: ListView.separated(
                                controller: _scrollController,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 25.h),
                                itemCount: state.commentsList.length + 1,
                                itemBuilder: (context, index) {
                                  if (state.commentsList.isNotEmpty &&
                                      index >= state.commentsList.length) {
                                    if (state.hasReachedMax) {
                                      return const SizedBox.shrink();
                                    } else {
                                      return SizedBox(
                                        height: 20.h,
                                        width: context.screenWidth,
                                        child: LoadingAnimation(
                                          height: 20.h,
                                          width: 20.w,
                                        ),
                                      );
                                    }
                                  } else {
                                    final comment = state.commentsList[index];
                                    return CommentItem(
                                      comment: comment,
                                      type: CommentType.mainComment,
                                      hasReplies: comment.replies.isNotEmpty,
                                      isFavorite: state.commentLikesIds
                                          .contains(comment.id),
                                      isEdited: comment.editedAt != '',
                                      onReplyTab: () {
                                        widget.onReplyTab(index);
                                      },
                                      onEditTab: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return BlocProvider.value(
                                              value: _commentsBloc,
                                              child: CommentOrReplyEditDialog(
                                                commentsBloc: _commentsBloc,
                                                originalContent:
                                                    comment.content,
                                                commentId: comment.id,
                                                onEditTab: (String
                                                    updatedContent) async {
                                                  if (comment.content !=
                                                      updatedContent) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();

                                                    _commentsBloc
                                                        .add(UpdateCommentEvent(
                                                      commentId: comment.id,
                                                      updatedContent:
                                                          updatedContent,
                                                    ));

                                                    context.maybePop();
                                                  }
                                                },
                                              ),
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
                                                message:
                                                    context.tr.deleteComment,
                                                buttonTitle: context.tr.yes,
                                                onTap: () async {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  _commentsBloc.add(
                                                    DeleteCommentEvent(
                                                      media: widget.media,
                                                      commentId: state
                                                          .commentsList[index]
                                                          .id,
                                                    ),
                                                  );
                                                  context.maybePop();
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      onFavoriteTap: () {
                                        _commentsBloc.add(
                                          AddOrRemoveCommentLikeEvent(
                                            commentId: comment.id,
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              }
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
                        controller: _commentController,
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

                      _commentsBloc.add(
                        AddCommentEvent(
                          media: widget.media,
                          commentMessage: _commentController.text,
                        ),
                      );
                      _commentController.clear();
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
