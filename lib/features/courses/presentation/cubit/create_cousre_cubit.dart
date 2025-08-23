// features/topics/presentation/cubit/topic_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/models/create_course_request_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/course_status_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_course_state.dart';

class CreateCourseCubit extends Cubit<CreateCourseState> {
  final CourseStatusRepository repository;

  CreateCourseCubit({required this.repository})
    : super(CourseCreationInitial());

  Future<void> createCourse({
    required CreateCourseRequestModel requestModel,
  }) async {
    try {
      emit(CourseLoading());

      final response = await repository.createCourse(
        requestModel: requestModel,
      );

      response.fold(
        (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
        (message) => emit(CourseSuccess(message: message)),
      );
    } catch (e) {
      emit(CourseFailure(errMessage: e.toString()));
    }
  }

  Future<void> deleteCourse({required int courseId}) async {
    try {
      emit(CourseLoading());

      final response = await repository.deleteCourse(courseId: courseId);
      response.fold(
        (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
        (message) => emit(CourseSuccess(message: message)),
      );
    } catch (e) {
      emit(CourseFailure(errMessage: e.toString()));
    }
  }

  Future<void> restoreCourse({required int courseId}) async {
    try {
      emit(CourseLoading());

      final response = await repository.restoreCourse(courseId: courseId);
      response.fold(
        (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
        (message) => emit(CourseSuccess(message: message)),
      );
    } catch (e) {
      emit(CourseFailure(errMessage: e.toString()));
    }
  }
  Future<void> deleteDraftCourse({required int courseId}) async {
    try {
      emit(CourseLoading());

      final response = await repository.deleteDraftCourse(courseId: courseId);
      response.fold(
        (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
        (message) => emit(CourseSuccess(message: message)),
      );
    } catch (e) {
      emit(CourseFailure(errMessage: e.toString()));
    }
  }

  Future<void> updateDraftCourse({
    required CreateCourseRequestModel requestModel,
    required int courseId,
  }) async {
    try {
      emit(CourseLoading());

      final response = await repository.updateDraftCourse(
        requestModel: requestModel,
        courseId: courseId,
      );

      response.fold(
        (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
        (message) => emit(CourseSuccess(message: message)),
      );
    } catch (e) {
      emit(CourseFailure(errMessage: e.toString()));
    }
  }
  Future<void> updateCourseCopy({
    required CreateCourseRequestModel requestModel,
    required int courseId,
  }) async {
    try {
      emit(CourseLoading());

      final response = await repository.updateCourseCopy(
        requestModel: requestModel,
        courseId: courseId,
      );

      response.fold(
        (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
        (message) => emit(CourseSuccess(message: message)),
      );
    } catch (e) {
      emit(CourseFailure(errMessage: e.toString()));
    }
  }

  Future<void> updateApprovedCourse({
    required double price,
    required int courseId,
  }) async {
    try {
      emit(CourseLoading());

      final response = await repository.updateApprovedCourse(
        price: price,
        courseId: courseId,
      );

      response.fold(
        (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
        (message) => emit(CourseSuccess(message: message)),
      );
    } catch (e) {
      emit(CourseFailure(errMessage: e.toString()));
    }
  }
   Future<void> publishCourse(int courseId,bool isCopy) async {
    emit(CourseLoading());
    final response = await repository.publishCourse(courseId,isCopy);
    response.fold(
      (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
      (publishcourse) => emit(CourseSuccess(message: publishcourse)));
  }
   Future<void> cancelUpdate(int courseId) async {
    emit(CourseLoading());
    final response = await repository.cancelUpdate(courseId);
    response.fold(
      (failure) => emit(CourseFailure(errMessage: failure.errMessage)),
      (publishcourse) => emit(CourseSuccess(message: publishcourse)));
  }


}
