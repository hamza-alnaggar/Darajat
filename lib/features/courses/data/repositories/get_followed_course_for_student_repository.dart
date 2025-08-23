import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/get_followed_course_for_student_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

class GetFollowedCourseForStudentRepository {
  final GetFollowedCourseForStudentRemoteDataSource remoteDataSource;

  GetFollowedCourseForStudentRepository({required this.remoteDataSource});

  Future<Either<Failure, CourseResponseModel>> getFlolowedCourseForStudent(
      ) async {
    try {
      final response = await remoteDataSource.getFlolowedCourseForStudent();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}