

abstract class RateCourseState {}

class RateCourseInitial extends RateCourseState {}

class RateCourseLoading extends RateCourseState {}

class RateCourseSuccess extends RateCourseState {
  final String message;
  RateCourseSuccess({required this.message});
}
class RateCourseFailure extends RateCourseState {
  final String errMessage;

  RateCourseFailure({required this.errMessage});
}