import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

abstract class GetCourseForTecherState {}

class GetCourseForTecherInitial extends GetCourseForTecherState {}

class CoursesByStatusLoading extends GetCourseForTecherState {}
class CoursesByStatusLoaded extends GetCourseForTecherState {
  final List<CourseModel> courses;
  final String message;
  final String status;
  CoursesByStatusLoaded({required this.courses, required this.message,required this.status});
}
class CoursesByStatusFailure extends GetCourseForTecherState {
  final String errMessage;
  CoursesByStatusFailure({required this.errMessage});
}