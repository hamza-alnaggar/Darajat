import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/course_list_response.dart';

class GetCourseForTecherRemoteDataSource {
  final ApiConsumer api;

  GetCourseForTecherRemoteDataSource({required this.api});

  Future<CourseListResponse> getCoursesByStatus(
    String status, 
    {int ?topicId}
  ) async {
   

    String endpoint = _getStatusEndpoint(status);
  if(topicId!=null)
  endpoint = "$endpoint/$topicId";
    
    final response = await api.get(
      '$endpoint',
    options: Options(extra: {'authRequired': true}, )
    );
    return CourseListResponse.fromJson(response);
  }

  String _getStatusEndpoint(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
        return EndPoints.rejectedCourses;
      case 'approved':
        return EndPoints.approvedCourses;
      case 'pending':
        return EndPoints.pendingCourses;
      case 'draft':
        return EndPoints.draftCourses;
      case 'deleted':
        return EndPoints.deletedCourses;
      case 'witharrangement':
        return EndPoints.coursesWithArrangement;
      default:
        throw ArgumentError('Invalid course status: $status');
    }
  }
}