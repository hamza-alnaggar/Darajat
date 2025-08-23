import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/comment/data/models/comment_model.dart';
import 'package:learning_management_system/features/comment/data/models/meta_model.dart';
import 'package:learning_management_system/features/comment/data/repositories/comment_repository.dart';
import 'package:learning_management_system/features/comment/presentation/cubit/comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository repository;

  CommentCubit({required this.repository}) : super(CommentInitial());

  Future<void> getInitialComments(int postId) async {
    try {
      emit(CommentLoading(comments: state.comments, meta: state.meta));
      final result = await repository.getInitialComments(postId);
      result.fold(
        (failure) => emit(CommentFailure(
          comments: state.comments,
          errMessage: failure.errMessage,
          meta: state.meta,
        )),
        (response) => emit(CommentLoaded(
          comments: response.comments,
          meta: response.meta,
          message: response.message,
        )),
      );
    } catch (e) {
      emit(CommentFailure(
        comments: state.comments,
        errMessage: e.toString(),
        meta: state.meta,
      ));
    }
  }

  Future<void> loadMoreComments(int postId) async {
    if (state.meta?.hasMorePages != true) return;
    
    try {
      emit(CommentLoadingMore(
        comments: state.comments,
        meta: state.meta,
      ));
      
      final result = await repository.loadMoreComments(
        postId, 
        state.meta!.nextPage!
      );
      
      result.fold(
        (failure) => emit(CommentLoadMoreError(
          comments: state.comments,
          meta: state.meta,
          errMessage: failure.errMessage,
        )),
        (response) {
          final updatedComments = [
            ...state.comments,
            ...response.comments
          ];
          emit(CommentLoaded(
            comments: updatedComments,
            meta: response.meta,
            message: response.message,
          ));
        },
      );
    } catch (e) {
      emit(CommentLoadMoreError(
        comments: state.comments,
        meta: state.meta,
        errMessage: e.toString(),
      ));
    }
  }

  Future<void> getMyComments(int postId) async {
    try {
      emit(CommentLoading(comments: state.comments, meta: state.meta));
      final result = await repository.getMyComments(postId);
      result.fold(
        (failure) => emit(CommentFailure(
          comments: state.comments,
          errMessage: failure.errMessage,
          meta: state.meta,
        )),
        (response) => emit(CommentLoaded(
          comments: response.comments,
          message: response.message,
        )),
      );
    } catch (e) {
      emit(CommentFailure(
        comments: state.comments,
        errMessage: e.toString(),
        meta: state.meta,
      ));
    }
  }

 Future<void> addComment(int episodeId, String content) async {
  try {
    emit(CommentOperationInProgress(
      comments: state.comments,
      meta: state.meta,
    ));
    
    final result = await repository.addComment(
      episodeId: episodeId,
      content: content,
    );

    result.fold(
      (failure) => emit(CommentFailure(
        comments: state.comments,
        errMessage: failure.errMessage,
        meta: state.meta,
      )),
      (newComment) {
        final updatedComments = [newComment, ...state.comments];
        final newMeta = state.meta != null
            ? MetaModel(
                currentPage: state.meta!.currentPage,
                hasMorePages: state.meta!.hasMorePages,
                nextPage: state.meta!.nextPage,
              )
            : null;
        
        emit(CommentLoaded(
          comments: updatedComments,
          meta: newMeta,
          message: 'Comment added successfully',
        ));
      },
    );
  } catch (e) {
    emit(CommentFailure(
      comments: state.comments,
      errMessage: e.toString(),
      meta: state.meta,
    ));
  }
}

 Future<void> updateComment(int commentId, String content) async {
  try {
    emit(CommentOperationInProgress(comments: state.comments, meta: state.meta));
    
    final result = await repository.updateComment(
      commentId: commentId,
      content: content,
    );

    result.fold(
      (failure) => emit(CommentFailure(
        comments: state.comments,
        errMessage: failure.errMessage,
        meta: state.meta,
      )),
      (response) {
        // Update the comment in the list
        final updatedComments = [...state.comments];
        final index = updatedComments.indexWhere((c) => c.id == commentId);
        
        if (index != -1) {
          // Use the first comment from the response
          updatedComments[index] = response;
        }
        
        emit(CommentLoaded(
          comments: updatedComments,
          meta: state.meta,
          message: 'update success',
        ));
      },
    );
  } catch (e) {
    emit(CommentFailure(
      comments: state.comments,
      errMessage: e.toString(),
      meta: state.meta,
    ));
  }
}

 // في ملف comment_cubit.dart
Future<void> deleteComment(int commentId, {bool isTeacher = false}) async {
  try {
    emit(CommentOperationInProgress(
      comments: state.comments,
      meta: state.meta,
    ));
    
    final result = await repository.deleteComment(commentId, isTeacher);

    result.fold(
      (failure) => emit(CommentFailure(
        comments: state.comments,
        errMessage: failure.errMessage,
        meta: state.meta,
      )),
      (response) {
        final updatedComments = state.comments
            .where((c) => c.id != commentId)
            .toList();
        
        emit(CommentOperationSuccess(
          comments: updatedComments,
          meta: state.meta,
          message: response,
        ));
      },
    );
  } catch (e) {
    emit(CommentFailure(
      comments: state.comments,
      errMessage: e.toString(),
      meta: state.meta,
    ));
  }
}
  Future<void> addLikeComment(int commentId) async {
    final currentState = state;
    if (currentState is CommentLoaded) {
      emit(CommentOperationInProgress(
        comments: currentState.comments,
        meta: currentState.meta,
      ));
    }

    // Optimistic update
    final index = state.comments.indexWhere((c) => c.id == commentId);
    if (index != -1) {
      final updatedComments = List<CommentModel>.from(state.comments);
      final comment = updatedComments[index];
      updatedComments[index] = comment.copyWith(
        likes: comment.likes + 1,
        isLiked: true,
      );
      emit(CommentLoaded(comments: updatedComments, meta: state.meta));
    }

    final result = await repository.addLike(commentId);

    result.fold(
      (failure) {
        if (currentState is CommentLoaded) {
          emit(CommentLoaded(comments: currentState.comments, meta: currentState.meta));
        }
        emit(CommentFailure(
          comments: state.comments,
          meta: state.meta,
          errMessage: failure.errMessage,
        ));
      },
      (response) {
        // Update with actual server response
        if (index != -1) {
          final updatedComments = List<CommentModel>.from(state.comments);
          updatedComments[index] = response;
          emit(CommentLoaded(comments: updatedComments, meta: state.meta));
        }
      },
    );
  }

  Future<void> removeLikeComment(int commentId) async {
    final currentState = state;
    if (currentState is CommentLoaded) {
      emit(CommentOperationInProgress(
        comments: currentState.comments,
        meta: currentState.meta,
      ));
    }

    // Optimistic update
    final index = state.comments.indexWhere((c) => c.id == commentId);
    if (index != -1) {
      final updatedComments = List<CommentModel>.from(state.comments);
      final comment = updatedComments[index];
      updatedComments[index] = comment.copyWith(
        likes: comment.likes > 0 ? comment.likes - 1 : 0,
        isLiked: false,
      );
      emit(CommentLoaded(comments: updatedComments, meta: state.meta));
    }

    final result = await repository.removeLike(commentId);

    result.fold(
      (failure) {
        if (currentState is CommentLoaded) {
          emit(CommentLoaded(comments: currentState.comments, meta: currentState.meta));
        }
        emit(CommentFailure(
          comments: state.comments,
          meta: state.meta,
          errMessage: failure.errMessage,
        ));
      },
      (response) {
        // Update with actual server response
        if (index != -1) {
          final updatedComments = List<CommentModel>.from(state.comments);
          updatedComments[index] = response;
          emit(CommentLoaded(comments: updatedComments, meta: state.meta));
        }
      },
    );
  }
}