import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/rate_course_remote_data_source.dart';

class RateCourseRepository {
  final RateCourseRemoteDataSource remoteDataSource;

  RateCourseRepository({required this.remoteDataSource});

  Future<Either<Failure, String>> rateCourse(
    int courseId,
    int rate
      ) async {
    try {
      final response = await remoteDataSource.rateCourse(courseId,rate);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}