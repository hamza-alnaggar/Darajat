// features/topics/data/datasources/topic_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

class GetFollowedCourseForStudentRemoteDataSource {
  final ApiConsumer api;

  GetFollowedCourseForStudentRemoteDataSource({required this.api});

  Future<CourseResponseModel> getFlolowedCourseForStudent() async {

 
  final response = await api.get(
    '${EndPoints.coursesfollowed}',
    options: Options(extra: {'authRequired': true},)
  );

  return CourseResponseModel.fromJson(response);
}
}