import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/get_course_for_techer_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/models/course_list_response.dart';

class GetCourseForTecherRepository {
  final GetCourseForTecherRemoteDataSource remoteDataSource;

  GetCourseForTecherRepository({required this.remoteDataSource});

  Future<Either<Failure, CourseListResponse>> getCoursesByStatus(
    String status, 
    {int ?topicId}
  ) async {
    try {
      final response = await remoteDataSource.getCoursesByStatus(status,topicId: topicId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}