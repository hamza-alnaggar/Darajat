// features/topics/data/datasources/topic_remote_data_source.dart
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';

class TopicRemoteDataSource {
  final ApiConsumer api;

  TopicRemoteDataSource({required this.api});

  Future<TopicResponseModel> getTopicsByCategory(int categoryId) async {
    final response = await api.get(
      "${EndPoints.topicsInCategory}/$categoryId"
    );
    return TopicResponseModel.fromJson(response);
  }
}