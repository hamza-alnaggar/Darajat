import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/show_course_for_techer_remote_data_sourse.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';

class ShowCourseForTecherRepository {
  final ShowCourseForTecherRemoteDataSourse remoteDataSource;

  ShowCourseForTecherRepository({required this.remoteDataSource});

  Future<Either<Failure, CourseDetailsModel>> showCourseForTeacher(
    int courseId,
    bool isCopy
      ) async {
    try {
      final response = await remoteDataSource.showCourse(courseId,isCopy);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}