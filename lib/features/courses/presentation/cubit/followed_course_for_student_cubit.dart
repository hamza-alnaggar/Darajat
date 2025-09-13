// features/topics/presentation/cubit/topic_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/repositories/get_followed_course_for_student_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/followed_courses_for_student_state.dart';


class FollowedCourseForStudentCubit extends Cubit<FollowedCoursesForStudentState> {
  final GetFollowedCourseForStudentRepository repository;

  FollowedCourseForStudentCubit({required this.repository}) : super(GetFollowedCoursesInitial());
  
  Future<void> getFollowedCourse() async {
    emit(GetFollowedCoursesLoading());
    final response = await repository.getFlolowedCourseForStudent();
    response.fold(
      (failure) => emit(GetFollowedCoursesFailure(errMessage: failure.errMessage)),
      (courses) => emit(GetFollowedCoursesSuccess(courses: courses)));
  }
  }
