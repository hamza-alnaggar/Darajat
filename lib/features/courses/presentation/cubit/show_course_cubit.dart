// features/topics/presentation/cubit/topic_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/repositories/show_course_for_student_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/show_course_for_techer_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_state.dart';


class ShowCourseCubit extends Cubit<ShowCourseState> {
  final ShowCourseForTecherRepository teacherRepository;
  final ShowCourseForStudentRepository studentRepository;

  ShowCourseCubit({required this.teacherRepository,required this.studentRepository}) : super(ShowCourseInitial());

  
  Future<void> showCourseForStudent(int courseId) async {
    emit(ShowCourseLoading());
    final response = await studentRepository.showCourseForStudent(courseId);
    response.fold(
      (failure) => emit(ShowCourseFailure(errMessage: failure.errMessage)),
      (publishcourse) => emit(ShowCourseSuccess(course: publishcourse)));
  }
  Future<void> showCourseForTeacher(int courseId,bool isCopy) async {
    emit(ShowCourseLoading());
    final response = await teacherRepository.showCourseForTeacher(courseId,isCopy);
    response.fold(
      (failure) => emit(ShowCourseFailure(errMessage: failure.errMessage)),
      (publishcourse) => emit(ShowCourseSuccess(course: publishcourse)));
  }
  }
