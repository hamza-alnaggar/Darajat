// features/topics/presentation/cubit/topic_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/repositories/rate_course_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/rate_course_state.dart';


class RateCourseCubit extends Cubit<RateCourseState> {
  final RateCourseRepository repository;

  RateCourseCubit({required this.repository}) : super(RateCourseInitial());

  
  Future<void> rateCourse(int courseId,int rate) async {
    emit(RateCourseLoading());
    final response = await repository.rateCourse(courseId,rate);
    response.fold(
      (failure) => emit(RateCourseFailure(errMessage: failure.errMessage)),
      (publishcourse) => emit(RateCourseSuccess(message: publishcourse)));
  }
  
  }
