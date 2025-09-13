// features/topics/presentation/cubit/topic_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/topic_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_state.dart';


class TopicCubit extends Cubit<TopicState> {
  final TopicRepository repository;

  TopicCubit({required this.repository}) : super(TopicInitial());

  List<TopicModel> topicList = [];
  TopicModel ?selectedTopic ;




  Future<void> getTopicsByCategory(int categoryId) async {
    emit(TopicLoading());
    final response = await repository.getTopicsByCategory(categoryId);
    response.fold(
      (failure) => emit(TopicFailure(errMessage: failure.errMessage)),
      (topicsResponse) {
        if (topicsResponse.data.isEmpty) {
          emit(TopicEmpty());
        } else {
          topicList = topicsResponse.data;
          emit(TopicSuccess(topics: topicsResponse.data));
        }
      },
    );
  }
  void selectTopic(TopicModel ?topic) {
    selectedTopic = topic;
    emit(ChangeTopic());  
  }
  void resetTopic() {
    selectedTopic = null;
  emit(TopicSuccess(topics: [])); 
}
}