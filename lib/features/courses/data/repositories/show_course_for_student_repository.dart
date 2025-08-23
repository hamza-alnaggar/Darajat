import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/show_course_for_student_remote_data_sourse.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';

class ShowCourseForStudentRepository {
  final ShowCourseForStudentRemoteDataSourse remoteDataSource;

  ShowCourseForStudentRepository({required this.remoteDataSource});

  Future<Either<Failure, CourseDetailsModel>> showCourseForStudent(
    int courseId
      ) async {
    try {
      final response = await remoteDataSource.showCourse(courseId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}