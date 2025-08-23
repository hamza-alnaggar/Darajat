// courses_state.dart
abstract class CreateCourseState {}

class CourseCreationInitial extends CreateCourseState {}
class CourseLoading extends CreateCourseState {}

class CourseSuccess extends CreateCourseState {
  final String message;
  CourseSuccess({required this.message});
}
class CourseFailure extends CreateCourseState {
  final String errMessage;
  CourseFailure({required this.errMessage});
}
