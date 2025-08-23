import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

class CoursesRepository {
  final CoursesRemoteDataSource remoteDataSource;

  CoursesRepository({required this.remoteDataSource});

  Future<Either<Failure, CourseResponseModel>> getAllCourses() async {
    try {
      final response = await remoteDataSource.getAllCourses();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, CourseDetailsModel>> showCourse(int courseId) async {
    try {
      final response = await remoteDataSource.showCourse(courseId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, CourseResponseModel>> loadMoreCourses(String page,String type) async {
    try {
      final response = await remoteDataSource.loadMoreCourses(page,type);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, CourseResponseModel>> getPaidCourses() async {
    try {
      final response = await remoteDataSource.getPaidCourses();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, CourseResponseModel>> getCourseByCategory(String query) async {
    try {
      final response = await remoteDataSource.getCourseByCategory(query);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, CourseResponseModel>> getCourseByTopic(String query) async {
    try {
      final response = await remoteDataSource.getCourseByTopic(query);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, CourseResponseModel>> getFreeCourses() async {
    try {
      final response = await remoteDataSource.getFreeCourses();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, CourseResponseModel>> searchCourses(String query) async {
    try {
      final response = await remoteDataSource.searchCourses(query);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}