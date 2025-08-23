

import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

abstract class FollowedCoursesForStudentState {}

class GetFollowedCoursesInitial extends FollowedCoursesForStudentState {}

class GetFollowedCoursesLoading extends FollowedCoursesForStudentState {}

class GetFollowedCoursesSuccess extends FollowedCoursesForStudentState {
  final CourseResponseModel courses;
  GetFollowedCoursesSuccess({required this.courses});
}
class GetFollowedCoursesFailure extends FollowedCoursesForStudentState {
  final String errMessage;

  GetFollowedCoursesFailure({required this.errMessage});
}