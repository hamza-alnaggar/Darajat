
import 'package:learning_management_system/features/comment/data/models/comment_model.dart';
import 'package:learning_management_system/features/comment/data/models/meta_model.dart';

abstract class CommentState {
  final List<CommentModel> comments;
  final MetaModel? meta;
  final String? message;
  
  const CommentState({
    required this.comments,
    this.meta,
    this.message,
  });
}

class CommentInitial extends CommentState {
  const CommentInitial() : super(comments: const []);
}

class CommentLoading extends CommentState {
  const CommentLoading({required super.comments, super.meta});
}

class CommentLoaded extends CommentState {
  const CommentLoaded({
    required super.comments,
    super.meta,
    super.message,
  });
}

class CommentLoadingMore extends CommentState {
  const CommentLoadingMore({
    required super.comments,
    required super.meta,
  });
}

class CommentLoadMoreError extends CommentState {
  final String errMessage;
  
  const CommentLoadMoreError({
    required super.comments,
    required super.meta,
    required this.errMessage,
  });
}

class CommentOperationInProgress extends CommentState {
  const CommentOperationInProgress({
    required super.comments,
    super.meta,
  });
}

class CommentOperationSuccess extends CommentState {
  const CommentOperationSuccess({
    required super.comments,
    super.meta,
    required super.message,
  });
}

class CommentFailure extends CommentState {
  final String errMessage;
  
  const CommentFailure({
    required super.comments,
    super.meta,
    required this.errMessage,
  });
}