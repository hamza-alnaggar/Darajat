import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/comment/data/models/reply_model.dart';
import 'package:learning_management_system/features/comment/data/repositories/reply_repository.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final ReplyRepository repository;
  final int commentId;

  ReplyCubit({
    required this.repository,
    required this.commentId,
  }) : super(ReplyInitial());

  List<ReplyModel> replies = [];

  Future<void> getReplies() async {
    try {
      emit(ReplyLoading());
      final result = await repository.getReplies(commentId);
      result.fold(
        (failure) => emit(ReplyFailure(errMessage: failure.errMessage)),
        (response) {
          replies = response.replies;
          emit(RepliesLoaded(replies: replies));
        },
      );
    } catch (e) {
      emit(ReplyFailure(errMessage: e.toString()));
    }
  }

  Future<void> addReply(String content) async {
    final currentState = state;
    if (currentState is RepliesLoaded) {
      emit(ReplyOperationInProgress(replies: replies));
    }

    final result = await repository.addReply(
      commentId: commentId,
      content: content,
    );

    result.fold(
      (failure) {
        if (currentState is RepliesLoaded) {
          emit(RepliesLoaded(replies: replies));
        }
        emit(ReplyFailure(errMessage: failure.errMessage));
      },
      (response) {
        // Append new reply at the end (newest at bottom)
        replies = [...replies, response.reply];
        emit(RepliesLoaded(replies: replies));
      },
    );
  }

  Future<void> updateReply(int replyId, String content) async {
    final currentState = state;
    if (currentState is RepliesLoaded) {
      emit(ReplyOperationInProgress(replies: replies));
    }

    final result = await repository.updateReply(
      replyId: replyId,
      content: content,
    );

    result.fold(
      (failure) {
        if (currentState is RepliesLoaded) {
          emit(RepliesLoaded(replies: replies));
        }
        emit(ReplyFailure(errMessage: failure.errMessage));
      },
      (response) {
        final index = replies.indexWhere((r) => r.id == replyId);
        if (index != -1) {
          replies[index] = response;
          emit(RepliesLoaded(replies: replies));
        }
      },
    );
  }

  Future<void> deleteReply(int replyId, {bool isTeacher = false}) async {
    final currentState = state;
    if (currentState is RepliesLoaded) {
      emit(ReplyOperationInProgress(replies: replies));
    }

    final result = await repository.deleteReply(replyId, isTeacher);

    result.fold(
      (failure) {
        if (currentState is RepliesLoaded) {
          emit(RepliesLoaded(replies: replies));
        }
        emit(ReplyFailure(errMessage: failure.errMessage));
      },
      (response) {
        replies.removeWhere((r) => r.id == replyId);
        emit(RepliesLoaded(replies: replies));
      },
    );
  }

  Future<void> addLikeReply(int replyId) async {
    final currentState = state;
    if (currentState is RepliesLoaded) {
      emit(ReplyOperationInProgress(replies: replies));
    }

    final index = replies.indexWhere((r) => r.id == replyId);
    if (index != -1) {
      final optimisticReply = replies[index].copyWith(
        likes: replies[index].likes + 1,
        isLiked: true,
      );
      final optimisticReplies = List<ReplyModel>.from(replies);
      optimisticReplies[index] = optimisticReply;
      emit(RepliesLoaded(replies: optimisticReplies));
    }

    final result = await repository.addLikeReply(replyId);

    result.fold(
      (failure) {
        if (currentState is RepliesLoaded) {
          emit(RepliesLoaded(replies: replies));
        }
        emit(ReplyFailure(errMessage: failure.errMessage));
      },
      (response) {
        // Update with actual server response
        if (index != -1) {
          replies[index] = response.reply;
          emit(RepliesLoaded(replies: replies));
        }
      },
    );
  }

  Future<void> removeLikeReply(int replyId) async {
    final currentState = state;
    if (currentState is RepliesLoaded) {
      emit(ReplyOperationInProgress(replies: replies));
    }

    // Optimistic update: decrement like
    final index = replies.indexWhere((r) => r.id == replyId);
    if (index != -1) {
      final optimisticReply = replies[index].copyWith(
        isLiked: false,
        likes: replies[index].likes > 0 ? replies[index].likes - 1 : 0,
      );
      final optimisticReplies = List<ReplyModel>.from(replies);
      optimisticReplies[index] = optimisticReply;
      emit(RepliesLoaded(replies: optimisticReplies));
    }

    // IMPORTANT: call the remove-like endpoint if available
    // If your repository only has a toggle method, use that instead.
    final result = await repository.addLikeReply(replyId);

    result.fold(
      (failure) {
        if (currentState is RepliesLoaded) {
          emit(RepliesLoaded(replies: replies));
        }
        emit(ReplyFailure(errMessage: failure.errMessage));
      },
      (response) {
        if (index != -1) {
          replies[index] = response.reply;
          emit(RepliesLoaded(replies: replies));
        }
      },
    );
  }
}
