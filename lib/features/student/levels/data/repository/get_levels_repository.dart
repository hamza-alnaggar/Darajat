// features/levels/data/repositories/level_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/levels/data/datasource/get_levels_remote_data_source.dart';

import 'package:learning_management_system/features/student/levels/data/models/levels_respons_model.dart';

class GetLevelsRepository {
  final GetLevelsRemoteDataSource remoteDataSource;

  GetLevelsRepository({required this.remoteDataSource});

  Future<Either<Failure, LevelResponseModel>> getLevels() async {
    try {
      final response = await remoteDataSource.getLevels();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}