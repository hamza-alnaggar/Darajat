// courses_state.dart
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

abstract class CreateCourseState {}

class CourseCreationInitial extends CreateCourseState {}
class CourseLoading extends CreateCourseState {}

class CourseSuccess extends CreateCourseState {
  final String message;
  CourseSuccess({required this.message,
  });
}
class CreateCourseSuccessfully extends CreateCourseState {
  final CourseDetailsResponse course;
  CreateCourseSuccessfully({required this.course,
  });
}
class UpdateStatusSuccessfully extends CreateCourseState {
  final String message;
  UpdateStatusSuccessfully({required this.message,
  });
}

class CourseFailure extends CreateCourseState {
  final String errMessage;
  CourseFailure({required this.errMessage});
}
