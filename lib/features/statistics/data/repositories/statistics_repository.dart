// features/statistics/data/repositories/statistics_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/statistics/data/datasource/statistics_remote_data_source.dart';
import 'package:learning_management_system/features/statistics/data/models/statistics_resopnse_model.dart';

class StatisticsRepository {
  final StatisticsRemoteDataSource remoteDataSource;

  StatisticsRepository({required this.remoteDataSource});

  Future<Either<Failure, StatisticsResponseModel>> getStatistics() async {
    try {
      final response = await remoteDataSource.getStatistics();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}