part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();
}

class GetCommentsEvent extends CommentsEvent {
  final String mediaId;

  const GetCommentsEvent({required this.mediaId});

  @override
  List<Object> get props => [mediaId];
}

class AddCommentEvent extends CommentsEvent {
  final MediaModel media;
  final String commentMessage;

  const AddCommentEvent({required this.media, required this.commentMessage});

  @override
  List<Object> get props => [media, commentMessage];
}

class AddReplyEvent extends CommentsEvent {
  final String replyContent;
  final MediaModel media;

  const AddReplyEvent({
    required this.replyContent,
    required this.media,
  });

  @override
  List<Object> get props => [
        replyContent,
        media,
      ];
}

class DeleteCommentEvent extends CommentsEvent {
  final MediaModel media;
  final String commentId;

  const DeleteCommentEvent({
    required this.media,
    required this.commentId,
  });

  @override
  List<Object> get props => [
        media,
        commentId,
      ];
}

class GetCommentLikesIdsEvent extends CommentsEvent {
  const GetCommentLikesIdsEvent();

  @override
  List<Object> get props => [];
}

class AddOrRemoveCommentLikeEvent extends CommentsEvent {
  final String commentId;

  const AddOrRemoveCommentLikeEvent({required this.commentId});

  @override
  List<Object> get props => [commentId];
}

class DeleteReplyEvent extends CommentsEvent {
  final MediaModel media;
  final String replyId;

  const DeleteReplyEvent({
    required this.media,
    required this.replyId,
  });

  @override
  List<Object> get props => [
        media,
        replyId,
      ];
}

class AddOrRemoveReplyLikeEvent extends CommentsEvent {
  final String replyId;

  const AddOrRemoveReplyLikeEvent({
    required this.replyId,
  });

  @override
  List<Object> get props => [
        replyId,
      ];
}

class UpdateReplyEvent extends CommentsEvent {
  final String replyId;
  final String updatedContent;

  const UpdateReplyEvent({
    required this.replyId,
    required this.updatedContent,
  });

  @override
  List<Object> get props => [
        replyId,
        updatedContent,
      ];
}

class UpdateCommentEvent extends CommentsEvent {
  final String commentId;
  final String updatedContent;

  const UpdateCommentEvent({
    required this.commentId,
    required this.updatedContent,
  });

  @override
  List<Object> get props => [
        commentId,
        updatedContent,
      ];
}

class AssignParentIndexEvent extends CommentsEvent {
  final int parentIndex;

  const AssignParentIndexEvent({
    required this.parentIndex,
  });

  @override
  List<Object> get props => [
        parentIndex,
      ];
}
