import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/shared/data/models/comments/comment_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
import 'package:dazzify/features/user/data/requests/add_comment_request.dart';
import 'package:dazzify/features/user/data/requests/add_reply_request.dart';
import 'package:dazzify/features/user/data/requests/get_comments_request.dart';
import 'package:dazzify/features/user/data/requests/update_comment_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'comments_event.dart';
part 'comments_state.dart';

@injectable
class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final UserRepository _userRepository;
  int _commentsPage = 1;
  final int _commentsLimit = 20;
  bool isAddComment = false;

  CommentsBloc(this._userRepository) : super(const CommentsState()) {
    on<GetCommentsEvent>(_onGetCommentsEvent, transformer: droppable());
    on<AddCommentEvent>(_onAddCommentEvent);
    on<DeleteCommentEvent>(_onDeleteCommentsEvent);
    on<UpdateCommentEvent>(_onUpdateCommentEvent);
    on<AddReplyEvent>(_onAddReplyEvent);
    on<DeleteReplyEvent>(_onDeleteReplyEvent);
    on<UpdateReplyEvent>(_onUpdateReplyEvent);
    on<GetCommentLikesIdsEvent>(_onGetCommentLikesIdsEvent);
    on<AddOrRemoveCommentLikeEvent>(_onAddOrRemoveCommentLikeEvent);
    on<AddOrRemoveReplyLikeEvent>(_onAddOrRemoveReplyLikeEvent);
    on<AssignParentIndexEvent>(_onAssignParentIndexEvent);
  }

  Future<void> _onGetCommentsEvent(
    GetCommentsEvent event,
    Emitter<CommentsState> emit,
  ) async {
    if (!state.hasReachedMax) {
      if (state.commentsList.isEmpty) {
        emit(state.copyWith(getCommentsState: UiState.loading));
      }
      final result = await _userRepository.getComments(
        request: GetCommentsRequest(
          mediaId: event.mediaId,
          page: _commentsPage,
          limit: _commentsLimit,
        ),
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            getCommentsState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (reelsComments) {
          final hasReachedMax =
              reelsComments.isEmpty || reelsComments.length < _commentsLimit;
          emit(
            state.copyWith(
              getCommentsState: UiState.success,
              commentsList: List.of(state.commentsList)..addAll(reelsComments),
              hasReachedMax: hasReachedMax,
            ),
          );
          _commentsPage++;
        },
      );
    }
  }

  Future<void> _onAddCommentEvent(
    AddCommentEvent event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(addCommentState: UiState.loading));
    final result = await _userRepository.addComment(
      request: AddCommentRequest(
        mediaId: event.media.id,
        commentMessage: event.commentMessage,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          addCommentState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (newComment) {
        emit(
          state.copyWith(
            addCommentState: UiState.success,
            isAddComment: true,
            commentsList: [newComment, ...state.commentsList],
          ),
        );
        if (event.media.commentsCount != null) event.media.commentsCount! + 1;
      },
    );
  }

  Future<void> _onAddReplyEvent(
    AddReplyEvent event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(addCommentState: UiState.loading));
    final result = await _userRepository.addReply(
      request: AddReplyRequest(
        commentId: state.commentsList[state.selectedParentIndex].id,
        replyContent: event.replyContent,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          addCommentState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (newComment) {
        List<CommentModel> comments = List.from(state.commentsList);

        comments[state.selectedParentIndex].replies.insert(0, newComment);

        emit(
          state.copyWith(
            addCommentState: UiState.success,
            isAddComment: true,
            commentsList: comments,
          ),
        );
        if (event.media.commentsCount != null) event.media.commentsCount! + 1;
      },
    );
  }

  Future<void> _onDeleteCommentsEvent(
    DeleteCommentEvent event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(deleteCommentState: UiState.loading));

    final result = await _userRepository.deleteComment(
      commentId: event.commentId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteCommentState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        int commentIndex = state.commentsList.indexWhere(
          (comment) => comment.id == event.commentId,
        );
        int repliesNumber = state.commentsList[commentIndex].replies.length;
        emit(
          state.copyWith(
            deleteCommentState: UiState.success,
            isAddComment: false,
            commentsList: state.commentsList
              ..removeWhere((element) => element.id == event.commentId)
              ..toList(),
          ),
        );
        if (event.media.commentsCount != null) {
          event.media.commentsCount! - (repliesNumber + 1);
        }
      },
    );
  }

  Future<void> _onGetCommentLikesIdsEvent(
      GetCommentLikesIdsEvent event, Emitter<CommentsState> emit) async {
    final result = await _userRepository.getCommentLikesIds();
    result.fold(
      (failure) => emit(
        state.copyWith(
          commentLikeIdsState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (likesIds) => emit(
        state.copyWith(
          commentLikeIdsState: UiState.success,
          commentLikesIds: likesIds.toSet(),
        ),
      ),
    );
  }

  Future<void> _addCommentLike(
      Emitter<CommentsState> emit, String commentId) async {
    emit(
      state.copyWith(
        addCommentLikeState: UiState.success,
        commentLikesIds: Set.from(state.commentLikesIds)..add(commentId),
      ),
    );
    final commentIndex =
        state.commentsList.indexWhere((comment) => comment.id == commentId);
    state.commentsList[commentIndex].likesCount++;

    emit(state.copyWith(
      addCommentLikeState: UiState.loading,
      removeCommentLikeState: UiState.initial,
    ));
    final result = await _userRepository.addCommentLike(
      commentId: commentId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          addCommentLikeState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) {},
    );
  }

  Future<void> _removeCommentLike(
      Emitter<CommentsState> emit, String commentId) async {
    emit(
      state.copyWith(
        removeCommentLikeState: UiState.success,
        commentLikesIds: Set.from(state.commentLikesIds)..remove(commentId),
      ),
    );
    final commentIndex =
        state.commentsList.indexWhere((comment) => comment.id == commentId);

    state.commentsList[commentIndex].likesCount--;

    emit(state.copyWith(
      removeCommentLikeState: UiState.loading,
      addCommentLikeState: UiState.initial,
    ));
    await _userRepository.removeCommentLike(
      commentId: commentId,
    );
  }

  Future<void> _onAddOrRemoveCommentLikeEvent(
      AddOrRemoveCommentLikeEvent event, Emitter<CommentsState> emit) async {
    if (state.commentLikesIds.contains(event.commentId)) {
      await _removeCommentLike(emit, event.commentId);
    } else {
      await _addCommentLike(emit, event.commentId);
    }
  }

  Future<void> _onDeleteReplyEvent(
    DeleteReplyEvent event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(deleteCommentState: UiState.loading));

    final result = await _userRepository.deleteComment(
      commentId: event.replyId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteCommentState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        List<CommentModel> comments = List.from(state.commentsList);

        int replyIndex = comments[state.selectedParentIndex]
            .replies
            .indexWhere((element) => element.id == event.replyId);

        comments[state.selectedParentIndex].replies.removeAt(replyIndex);

        emit(
          state.copyWith(
            deleteCommentState: UiState.success,
            isAddComment: false,
            commentsList: comments,
          ),
        );
        if (event.media.commentsCount != null) event.media.commentsCount! - 1;
      },
    );
  }

  Future<void> _onAddOrRemoveReplyLikeEvent(
      AddOrRemoveReplyLikeEvent event, Emitter<CommentsState> emit) async {
    String parentCommentId = state.commentsList[state.selectedParentIndex].id;

    if (state.commentLikesIds.contains(event.replyId)) {
      await _removeReplyLike(
        emit: emit,
        replyId: event.replyId,
        parentCommentId: parentCommentId,
      );
    } else {
      await _addReplyLike(
        emit: emit,
        replyId: event.replyId,
        parentCommentId: parentCommentId,
      );
    }
  }

  Future<void> _addReplyLike({
    required Emitter<CommentsState> emit,
    required String replyId,
    required String parentCommentId,
  }) async {
    int parentCommentIndex = state.commentsList
        .indexWhere((comment) => comment.id == parentCommentId);

    int replyIndex = state.commentsList[parentCommentIndex].replies
        .indexWhere((comment) => comment.id == replyId);

    state.commentsList[parentCommentIndex].replies[replyIndex].likesCount++;

    emit(
      state.copyWith(
        addCommentLikeState: UiState.success,
        commentLikesIds: Set.from(state.commentLikesIds)..add(replyId),
      ),
    );
    await _userRepository.addCommentLike(commentId: replyId);
  }

  Future<void> _removeReplyLike({
    required Emitter<CommentsState> emit,
    required String replyId,
    required String parentCommentId,
  }) async {
    int parentCommentIndex = state.commentsList
        .indexWhere((comment) => comment.id == parentCommentId);

    int replyIndex = state.commentsList[parentCommentIndex].replies
        .indexWhere((comment) => comment.id == replyId);

    state.commentsList[parentCommentIndex].replies[replyIndex].likesCount--;

    emit(
      state.copyWith(
        removeCommentLikeState: UiState.success,
        commentLikesIds: Set.from(state.commentLikesIds)..remove(replyId),
      ),
    );
    await _userRepository.removeCommentLike(commentId: replyId);
  }

  Future<void> _onUpdateCommentEvent(
    UpdateCommentEvent event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(addCommentState: UiState.loading));
    final result = await _userRepository.updateComment(
      request: UpdateCommentRequest(
        commentId: event.commentId,
        content: event.updatedContent,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          addCommentState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedComment) {
        final commentIndex = state.commentsList
            .indexWhere((comment) => comment.id == event.commentId);

        final List<CommentModel> comments = List.from(state.commentsList);

        comments[commentIndex] = updatedComment;

        emit(
          state.copyWith(
            addCommentState: UiState.success,
            isAddComment: true,
            commentsList: comments,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateReplyEvent(
    UpdateReplyEvent event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(addCommentState: UiState.loading));
    final result = await _userRepository.updateComment(
      request: UpdateCommentRequest(
        commentId: event.replyId,
        content: event.updatedContent,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          addCommentState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedReply) {
        List<CommentModel> comments = List.from(state.commentsList);

        int replyIndex = comments[state.selectedParentIndex]
            .replies
            .indexWhere((comment) => comment.id == event.replyId);

        comments[state.selectedParentIndex].replies[replyIndex] = updatedReply;

        emit(
          state.copyWith(
            addCommentState: UiState.success,
            isAddComment: true,
            commentsList: comments,
          ),
        );
      },
    );
  }

  Future<void> _onAssignParentIndexEvent(
    AssignParentIndexEvent event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(selectedParentIndex: event.parentIndex));
  }
}
