import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/create_update_episode_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/models/create_episode_body_model.dart';

class CreateUpdateEpisodeRepository {
  final CreateUpdateEpisodeRemoteDataSource remoteDataSource;

  CreateUpdateEpisodeRepository({required this.remoteDataSource});

  Future<Either<Failure, String>> createEpisode({
    required int courseId,
    required CreateEpisodeBodyModel request,
    required bool isCopy,
  }) async {
    try {
      final response = await remoteDataSource.createEpisode(
        courseId,
        request,
        isCopy
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, String>> updateEpisode({
    required int episodeId,
    required CreateEpisodeBodyModel request,
    required bool isCopy,
  }) async {
    try {
      final response = await remoteDataSource.updateEpisode(
        episodeId,
        request,
        isCopy
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, String>> deleteEpisode(
      bool isCopy,
      int courseId) async {
    try {
      final response = await remoteDataSource.deleteEpisode(courseId,isCopy);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, String>> deleteFile(int episodeId,bool isCopy) async {
    try {
      final data = await remoteDataSource.deletePdf(episodeId,isCopy);
      return Right(data);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}