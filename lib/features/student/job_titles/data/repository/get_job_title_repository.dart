// features/education/data/repositories/education_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/job_titles/data/datasource/get_job_title_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetJobTitleRepository {
  final GetJobTitleRemoteDataSource remoteDataSource;

  GetJobTitleRepository({required this.remoteDataSource});

  Future<Either<Failure, GetCountryOrLanguageResponseModel>> getJobTitle() async {
    try {
      final response = await remoteDataSource.getJobTitle();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}

