import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

class CoursesRemoteDataSource {
  final ApiConsumer api;

  CoursesRemoteDataSource({required this.api});

  Future<CourseResponseModel> getAllCourses() async {
    final response = await api.get(EndPoints.allCourses);
    return CourseResponseModel.fromJson(response);
  }
  Future<CourseDetailsModel> showCourse(int courseId) async {
    final response = await api.get('${EndPoints.showCourse}/$courseId');
    return CourseDetailsModel.fromJson(response[ApiKey.data]);
  }
  Future<CourseResponseModel> loadMoreCourses(String page,String type) async {
    final response = await api.post(EndPoints.loadMoreCourse,data: {
      'page': page,
      'type':type
    });
    return CourseResponseModel.fromJson(response);
  }
  
  Future<CourseResponseModel> searchCourses(String query) async {
    final response = await api.get(
      '${EndPoints.searchCourse}/$query'
    );
    return CourseResponseModel.fromJson(response);
  }
  Future<CourseResponseModel> getCourseByCategory(String query) async {
    final response = await api.get(
      '${EndPoints.getCourseByCategory}/$query'
    );
    return CourseResponseModel.fromJson(response);
  }
  Future<CourseResponseModel> getCourseByTopic(String query) async {
    final response = await api.get(
      '${EndPoints.getCourseByTopic}/$query'
    );
    return CourseResponseModel.fromJson(response);
  }

  Future<CourseResponseModel> getPaidCourses() async {
    final response = await api.get(
      EndPoints.paidCourses,
    );
    return CourseResponseModel.fromJson(response);
  }

  Future<CourseResponseModel> getFreeCourses() async {
    final response = await api.get(
      EndPoints.freeCourses,
    );
    return CourseResponseModel.fromJson(response);
  }
}