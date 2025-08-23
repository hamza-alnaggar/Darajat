import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

class CourseListResponse {
  final bool status;
  final List<CourseModel> data;
  final String message;

  CourseListResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    return CourseListResponse(
      status: json['status'] as bool,
      data: (json['data'] as List)
          .map((courseJson) => CourseModel.fromJson(courseJson))
          .toList(),
      message: json['message'] as String,
    );
  }
}