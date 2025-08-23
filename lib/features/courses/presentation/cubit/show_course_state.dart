

import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';

abstract class ShowCourseState {}

class ShowCourseInitial extends ShowCourseState {}

class ShowCourseLoading extends ShowCourseState {}

class ShowCourseSuccess extends ShowCourseState {
  final CourseDetailsModel course;
  ShowCourseSuccess({required this.course});
}
class ShowCourseFailure extends ShowCourseState {
  final String errMessage;

  ShowCourseFailure({required this.errMessage});
}