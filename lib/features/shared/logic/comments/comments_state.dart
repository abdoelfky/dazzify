part of 'comments_bloc.dart';

class CommentsState extends Equatable {
  final UiState commentLikeIdsState;
  final UiState addCommentLikeState;
  final UiState removeCommentLikeState;
  final UiState getCommentsState;
  final UiState addCommentState;
  final UiState deleteCommentState;
  final List<CommentModel> commentsList;
  final Set<String> commentLikesIds;
  final String errorMessage;
  final bool hasReachedMax;
  final bool isAddComment;
  final int selectedParentIndex;

  const CommentsState({
    this.commentLikeIdsState = UiState.initial,
    this.addCommentLikeState = UiState.initial,
    this.removeCommentLikeState = UiState.initial,
    this.getCommentsState = UiState.initial,
    this.addCommentState = UiState.initial,
    this.deleteCommentState = UiState.initial,
    this.commentsList = const [],
    this.commentLikesIds = const {},
    this.errorMessage = "",
    this.hasReachedMax = false,
    this.isAddComment = false,
    this.selectedParentIndex = 0,
  });

  CommentsState copyWith({
    UiState? commentLikeIdsState,
    UiState? addCommentLikeState,
    UiState? removeCommentLikeState,
    UiState? getCommentsState,
    UiState? addCommentState,
    UiState? deleteCommentState,
    List<CommentModel>? commentsList,
    Set<String>? commentLikesIds,
    String? errorMessage,
    bool? hasReachedMax,
    bool? isAddComment,
    int? selectedParentIndex,
  }) {
    return CommentsState(
      commentLikeIdsState: commentLikeIdsState ?? this.commentLikeIdsState,
      addCommentLikeState: addCommentLikeState ?? this.addCommentLikeState,
      removeCommentLikeState:
          removeCommentLikeState ?? this.removeCommentLikeState,
      getCommentsState: getCommentsState ?? this.getCommentsState,
      addCommentState: addCommentState ?? this.addCommentState,
      deleteCommentState: deleteCommentState ?? this.deleteCommentState,
      commentsList: commentsList ?? this.commentsList,
      commentLikesIds: commentLikesIds ?? this.commentLikesIds,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isAddComment: isAddComment ?? this.isAddComment,
      selectedParentIndex: selectedParentIndex ?? this.selectedParentIndex,
    );
  }

  @override
  List<Object> get props => [
        commentLikeIdsState,
        addCommentLikeState,
        removeCommentLikeState,
        getCommentsState,
        addCommentState,
        deleteCommentState,
        commentsList,
        commentLikesIds,
        errorMessage,
        hasReachedMax,
        isAddComment,
        selectedParentIndex,
      ];
}
