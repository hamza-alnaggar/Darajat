
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

abstract class CoursesState {}

class CoursesInitial extends CoursesState {}

class AllCoursesLoading extends CoursesState {}

class AllCoursesSuccess extends CoursesState {
  final List<CourseModel> courses;
  final bool hasMore;
  AllCoursesSuccess(this.courses, {required this.hasMore});
}
class AllCoursesLoadingMore extends CoursesState {
  final List<CourseModel> currentCourses;
  AllCoursesLoadingMore(this.currentCourses);
}

class AllCoursesPaginationError extends CoursesState {
  final List<CourseModel> loadedCourses;
  final String message;
  AllCoursesPaginationError(this.loadedCourses, this.message);
}
class AllCoursesEmpty extends CoursesState {}

class AllCoursesFailure extends CoursesState {
  final String errMessage;

  AllCoursesFailure({required this.errMessage});
}
class FreeCoursesLoading extends CoursesState {}

class FreeCoursesSuccess extends CoursesState {
  final List<CourseModel> courses;
  final bool hasMore;
  FreeCoursesSuccess(this.courses, {required this.hasMore});
}
class FreeCoursesLoadingMore extends CoursesState {
  final List<CourseModel> currentCourses;
  FreeCoursesLoadingMore(this.currentCourses);
}

class FreeCoursesPaginationError extends CoursesState {
  final List<CourseModel> loadedCourses;
  final String message;
  FreeCoursesPaginationError(this.loadedCourses, this.message);
}
class FreeCoursesEmpty extends CoursesState {}

class FreeCoursesFailure extends CoursesState {
  final String errMessage;

  FreeCoursesFailure({required this.errMessage});
}
class PaidCoursesLoading extends CoursesState {}

class PaidCoursesSuccess extends CoursesState {
  final List<CourseModel> courses;
  final bool hasMore;
  PaidCoursesSuccess(this.courses, {required this.hasMore});
}
class PaidCoursesLoadingMore extends CoursesState {
  final List<CourseModel> currentCourses;
  PaidCoursesLoadingMore(this.currentCourses);
}

class PaidCoursesPaginationError extends CoursesState {
  final List<CourseModel> loadedCourses;
  final String message;
  PaidCoursesPaginationError(this.loadedCourses, this.message);
}
class PaidCoursesEmpty extends CoursesState {}

class PaidCoursesFailure extends CoursesState {
  final String errMessage;

  PaidCoursesFailure({required this.errMessage});
}


class GetCourseDetailsSuccessfully extends CoursesState {
  CourseDetailsModel courses;
  GetCourseDetailsSuccessfully({required this.courses});
}
class GetCourseDetialsLoading extends CoursesState{}
class GetCourseDetialsFailure extends CoursesState{
  String errMessage;

  GetCourseDetialsFailure({required this.errMessage});
}


