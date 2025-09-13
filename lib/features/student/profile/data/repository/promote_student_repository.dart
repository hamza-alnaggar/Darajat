// features/profile/data/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/promote_student_remote_data_sourse.dart';

class PromoteStudentRepository {
  final PromoteStudentRemoteDataSourse remoteDataSource;

  PromoteStudentRepository({required this.remoteDataSource});

  Future<Either<Failure, String>> promoteStudent() async {
    try {
      final response = await remoteDataSource.promoteStudent();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}