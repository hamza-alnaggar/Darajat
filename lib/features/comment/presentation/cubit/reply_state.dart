// reply_state.dart
part of 'reply_cubit.dart';

abstract class ReplyState {
  const ReplyState();
}

class ReplyInitial extends ReplyState {}

class ReplyLoading extends ReplyState {}

class ReplyOperationInProgress extends ReplyState {
    final List<ReplyModel> replies;
      const ReplyOperationInProgress({required this.replies});


}

class RepliesLoaded extends ReplyState {
  final List<ReplyModel> replies;

  const RepliesLoaded({required this.replies});
}

class ReplyFailure extends ReplyState {
  final String errMessage;

  const ReplyFailure({required this.errMessage});
}