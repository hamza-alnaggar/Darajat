// features/badges/data/repositories/badges_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/badges/data/datasource/badges_remote_data_source.dart';
import 'package:learning_management_system/features/badges/data/models/badges_response_model.dart';

class BadgesRepository {
  final BadgesRemoteDataSource remoteDataSource;

  BadgesRepository({required this.remoteDataSource});

  Future<Either<Failure, BadgesResponseModel>> getBadges() async {
    try {
      final response = await remoteDataSource.getBadges();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}