import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/repositories/get_course_for_techer_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_state.dart';

class GetCourseForTecherCubit extends Cubit<GetCourseForTecherState> {
  final GetCourseForTecherRepository repository;

  GetCourseForTecherCubit({required this.repository}) : super(GetCourseForTecherInitial());

  Future<void> getCoursesByStatus(String status,{int? topicId}) async {
    try {
      emit(CoursesByStatusLoading());
      
    final response = await repository.getCoursesByStatus(status,topicId: topicId);
      response.fold(
        (failure) => emit(CoursesByStatusFailure(errMessage: failure.errMessage)),
        (data) => emit(CoursesByStatusLoaded(
          courses: data.data,
          message: data.message,
          status: status
        )),
      );
    } catch (e) {
      emit(CoursesByStatusFailure(errMessage: e.toString()));
    }
  }
}