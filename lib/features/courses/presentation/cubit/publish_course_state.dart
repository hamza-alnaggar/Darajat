

abstract class PublishCourseState {}

class PublishCourseInitial extends PublishCourseState {}

class PublishCourseLoading extends PublishCourseState {}

class PublishCourseSuccess extends PublishCourseState {
  final String message;
  PublishCourseSuccess({required this.message});
}
class PublishCourseFailure extends PublishCourseState {
  final String errMessage;

  PublishCourseFailure({required this.errMessage});
}