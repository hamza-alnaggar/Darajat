// features/courses/presentation/cubit/course_search_state.dart
part of 'course_search_cubit.dart';

abstract class CourseSearchState {}

class CourseSearchInitial extends CourseSearchState {}

class CourseSearchLoading extends CourseSearchState {}

class CourseSearchSuccess extends CourseSearchState {
  final List<CourseModel> courses;
  CourseSearchSuccess({required this.courses});
}

class CourseSearchEmpty extends CourseSearchState {}

class CourseSearchFailure extends CourseSearchState {
  final String errMessage;
  CourseSearchFailure({required this.errMessage});
}
