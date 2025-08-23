

abstract class DeleteCourseState {}

class DeleteCourseInitial extends DeleteCourseState {}

class DeleteCourseLoading extends DeleteCourseState {}

class DeleteCourseSuccess extends DeleteCourseState {
  final String message;
  DeleteCourseSuccess({required this.message});
}
class DeleteCourseFailure extends DeleteCourseState {
  final String errMessage;

  DeleteCourseFailure({required this.errMessage});
}