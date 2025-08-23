// features/education/data/repositories/education_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/educations/data/datasource/get_educations_remote_data_source.dart';
import 'package:learning_management_system/features/student/educations/data/models/educations_respons_model.dart';

class GetEducationsRepository {
  final GetEducationsRemoteDataSource remoteDataSource;

  GetEducationsRepository({required this.remoteDataSource});

  Future<Either<Failure, EducationResponseModel>> getEducations() async {
    try {
      final response = await remoteDataSource.getEducations();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}

