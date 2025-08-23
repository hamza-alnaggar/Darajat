// features/courses/presentation/cubit/course_search_cubit.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/courses_repository.dart';

part 'course_search_state.dart';

class CourseSearchCubit extends Cubit<CourseSearchState> {
  final CoursesRepository repository;
  Timer? _debounce;

  CourseSearchCubit({required this.repository}) : super(CourseSearchInitial());

  void searchCourses(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        emit(CourseSearchInitial());
        return;
      }
      
      emit(CourseSearchLoading());
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    final response = await repository.searchCourses(query);
    response.fold(
      (failure) => emit(CourseSearchFailure(errMessage: failure.errMessage)),
      (coursesResponse) {
        if (coursesResponse.data.isEmpty) {
          emit(CourseSearchEmpty());
        } else {
          emit(CourseSearchSuccess(courses: coursesResponse.data));
        }
      },
    );
  }
  Future<void> getCoursesByCategory(String query) async {
    emit(CourseSearchLoading());
    final response = await repository.getCourseByCategory(query);
    response.fold(
      (failure) => emit(CourseSearchFailure(errMessage: failure.errMessage)),
      (coursesResponse) {
          if (coursesResponse.data.isEmpty) {
          emit(CourseSearchEmpty());
        } else {
          emit(CourseSearchSuccess(courses: coursesResponse.data));
        }
      },
    );
  }
  Future<void> getCoursesByTopic(String query) async {
    emit(CourseSearchLoading());
    final response = await repository.getCourseByTopic(query);
    response.fold(
      (failure) => emit(CourseSearchFailure(errMessage: failure.errMessage)),
      (coursesResponse) {
        if (coursesResponse.data.isEmpty) {
          emit(CourseSearchEmpty());
        } else {
          emit(CourseSearchSuccess(courses: coursesResponse.data));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}