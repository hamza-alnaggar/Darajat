// features/topics/data/datasources/topic_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';

class ShowCourseForTecherRemoteDataSourse {
  final ApiConsumer api;

  ShowCourseForTecherRemoteDataSourse({required this.api});

  Future<CourseDetailsModel> showCourse(int courseId,bool isCopy) async {

  final response = await api.get(
   isCopy? '${EndPoints.getCopyForCourse}/$courseId': '${EndPoints.showCourseForTecher}/$courseId',
    options: Options(extra: {'authRequired': true}, )
  );

  return CourseDetailsModel.fromJson(response['data']);
}

}