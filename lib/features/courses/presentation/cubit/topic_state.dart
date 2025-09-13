// features/topics/presentation/cubit/topic_state.dart

import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';

abstract class TopicState {}

class TopicInitial extends TopicState {}

class TopicLoading extends TopicState {}

class TopicSuccess extends TopicState {
  final List<TopicModel> ?topics;

  TopicSuccess({required this.topics});
}
class ChangeTopic extends TopicState{}

class TopicEmpty extends TopicState {}

class TopicFailure extends TopicState {
  final String errMessage;

  TopicFailure({required this.errMessage});
}