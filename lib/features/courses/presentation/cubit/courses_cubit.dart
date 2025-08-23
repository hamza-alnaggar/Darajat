import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/comment/data/models/meta_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/courses_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final CoursesRepository repository;

  // Pagination for All Courses
  int _currentPageForAll = 1;
  bool _hasReachedMaxForAll = false;
  List<CourseModel> allCourses = [];

  // Pagination for Free Courses
  int _currentPageForFree = 1;
  bool _hasReachedMaxForFree = false;
  List<CourseModel> freeCourses = [];

  // Pagination for Paid Courses
  int _currentPageForPaid = 1;
  bool _hasReachedMaxForPaid = false;
  List<CourseModel> paidCourses = [];

  CoursesCubit({required this.repository}) : super(CoursesInitial());

  // ==================== All Courses ====================
  Future<void> getAllCourses() async {
    try {
      emit(AllCoursesLoading());
      final response = await repository.getAllCourses();
      _handleInitialAllResponse(response);
    } catch (e) {
      emit(AllCoursesFailure(errMessage: e.toString()));
    }
  }
  Future<void> loadMoreCourses() async {
  switch (currentType) {
    case 'all':
      return loadMoreAllCourses();
    case 'free':
      return loadMoreFreeCourses();
    case 'paid':
      return loadMorePaidCourses();
    default:
      return loadMoreAllCourses();
  }
}

String get currentType {
  if (state is AllCoursesSuccess) return 'all';
  if (state is FreeCoursesSuccess) return 'free';
  if (state is PaidCoursesSuccess) return 'paid';
  return 'all';
}

  Future<void> loadMoreAllCourses() async {
    try {
      if (state is AllCoursesLoadingMore || _hasReachedMaxForAll) return;
      emit(AllCoursesLoadingMore(allCourses));
      final response = await repository.loadMoreCourses(_currentPageForAll.toString(), 'all');
      _handleAllPaginationResponse(response);
    } catch (e) {
      emit(AllCoursesPaginationError(allCourses, e.toString()));
    }
  }

  void _handleInitialAllResponse(Either<Failure, CourseResponseModel> response) {
    response.fold(
      (failure) => emit(AllCoursesFailure(errMessage: failure.errMessage)),
      (data) {
        allCourses = data.data;
        _updateAllPaginationState(data.meta!);
        emit(AllCoursesSuccess(allCourses, hasMore: data.meta!.hasMorePages!));
      },
    );
  }

  void _handleAllPaginationResponse(Either<Failure, CourseResponseModel> response) {
    response.fold(
      (failure) => emit(AllCoursesPaginationError(allCourses, failure.errMessage)),
      (data) {
        allCourses.addAll(data.data);
        if(allCourses.length == 0)
        emit(AllCoursesEmpty());
else
        {_updateAllPaginationState(data.meta!);
        emit(AllCoursesSuccess(allCourses, hasMore: data.meta!.hasMorePages!));}
      },
    );
  }

  void _updateAllPaginationState(MetaModel meta) {
    _currentPageForAll = meta.currentPage!;
    _hasReachedMaxForAll = !meta.hasMorePages!;
    if (meta.hasMorePages!) _currentPageForAll++;
  }

  // ==================== Free Courses ====================
  Future<void> getFreeCourses() async {
    try {
      // Reset pagination state
      _currentPageForFree = 1;
      _hasReachedMaxForFree = false;
      
      emit(FreeCoursesLoading());
      final response = await repository.getFreeCourses();
      _handleInitialFreeResponse(response);
    } catch (e) {
      emit(FreeCoursesFailure(errMessage: e.toString()));
    }
  }

  Future<void> loadMoreFreeCourses() async {
    try {
      if (state is FreeCoursesLoadingMore || _hasReachedMaxForFree) return;
      emit(FreeCoursesLoadingMore(freeCourses));
      final response = await repository.loadMoreCourses(_currentPageForFree.toString(), 'free');
      _handleFreePaginationResponse(response);
    } catch (e) {
      emit(FreeCoursesPaginationError(freeCourses, e.toString()));
    }
  }

  void _handleInitialFreeResponse(Either<Failure, CourseResponseModel> response) {
    response.fold(
      (failure) => emit(FreeCoursesFailure(errMessage: failure.errMessage)),
      (data) {
        freeCourses = data.data;
        if(freeCourses.length == 0)
        {emit(FreeCoursesEmpty());}

      else  {_updateFreePaginationState(data.meta!);
        emit(FreeCoursesSuccess(freeCourses, hasMore: data.meta!.hasMorePages!));}
      },
    );
  }

  void _handleFreePaginationResponse(Either<Failure, CourseResponseModel> response) {
    response.fold(
      (failure) => emit(FreeCoursesPaginationError(freeCourses, failure.errMessage)),
      (data) {
        freeCourses.addAll(data.data);
        _updateFreePaginationState(data.meta!);
        emit(FreeCoursesSuccess(freeCourses, hasMore: data.meta!.hasMorePages!));
      },
    );
  }

  void _updateFreePaginationState(MetaModel meta) {
    _currentPageForFree = meta.currentPage!;
    _hasReachedMaxForFree = !meta.hasMorePages!;
    if (meta.hasMorePages!) _currentPageForFree++;
  }

  // ==================== Paid Courses ====================
  Future<void> getPaidCourses() async {
    try {
      // Reset pagination state
      _currentPageForPaid = 1;
      _hasReachedMaxForPaid = false;
      
      emit(PaidCoursesLoading());
      final response = await repository.getPaidCourses();
      _handleInitialPaidResponse(response);
    } catch (e) {
      emit(PaidCoursesFailure(errMessage: e.toString()));
    }
  }

  Future<void> loadMorePaidCourses() async {
    try {
      if (state is PaidCoursesLoadingMore || _hasReachedMaxForPaid) return;
      emit(PaidCoursesLoadingMore(paidCourses));
      final response = await repository.loadMoreCourses(_currentPageForPaid.toString(), 'paid');
      _handlePaidPaginationResponse(response);
    } catch (e) {
      emit(PaidCoursesPaginationError(paidCourses, e.toString()));
    }
  }

  void _handleInitialPaidResponse(Either<Failure, CourseResponseModel> response) {
    response.fold(
      (failure) => emit(PaidCoursesFailure(errMessage: failure.errMessage)),
      (data) {
        paidCourses = data.data;
        if(paidCourses.length == 0 && paidCourses.isEmpty)
        {  
        emit(PaidCoursesEmpty());
        }
        else
        {_updatePaidPaginationState(data.meta!);
        emit(PaidCoursesSuccess(paidCourses, hasMore: data.meta!.hasMorePages!));}
      },
    );
  }

  void _handlePaidPaginationResponse(Either<Failure, CourseResponseModel> response) {
    response.fold(
      (failure) => emit(PaidCoursesPaginationError(paidCourses, failure.errMessage)),
      (data) {
        paidCourses.addAll(data.data);
        _updatePaidPaginationState(data.meta!);
        emit(PaidCoursesSuccess(paidCourses, hasMore: data.meta!.hasMorePages!));
      },
    );
  }

  void _updatePaidPaginationState(MetaModel meta) {
    _currentPageForPaid = meta.currentPage!;
    _hasReachedMaxForPaid = !meta.hasMorePages!;
    if (meta.hasMorePages!) _currentPageForPaid++;
  }


}