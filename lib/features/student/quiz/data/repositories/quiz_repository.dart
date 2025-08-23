// quiz_creation_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/quiz/data/datasources/quiz_remote_data_source.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_create_body.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

class QuizCreationRepository {
  final QuizCreationRemoteDataSource remoteDataSource;

  QuizCreationRepository({required this.remoteDataSource});

  Future<Either<Failure, QuizModel>> createQuiz({
    required QuizCreateBody request,
    required int episodeId,
    required bool isCopy
    
  }) async {
    try {
      final response = await remoteDataSource.createQuiz(request: request,episodeId: episodeId,isCopy: isCopy);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, QuizModel>> updateQuiz({
    required QuizCreateBody request,
    required int episodeId,
    required bool isCopy

  }) async {
    try {
      final response = await remoteDataSource.updateQuiz(request: request,episodeId: episodeId,isCopy: isCopy);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, QuizModel>> deleteQuiz({
        required int episodeId,
        required bool isCopy

  }) async {
    try {
      final response = await remoteDataSource.deleteQuiz(episodeId: episodeId,isCooy: isCopy);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}