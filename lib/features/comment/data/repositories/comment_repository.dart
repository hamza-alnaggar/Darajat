import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:learning_management_system/features/comment/data/models/comment_model.dart';
import 'package:learning_management_system/features/comment/data/models/comment_response_model.dart';


class CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepository({required this.remoteDataSource});

  Future<Either<Failure, CommentResponseModel>> getInitialComments(
      int episodeId) async {
    try {
      final response = await remoteDataSource.getInitialComments(episodeId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, CommentResponseModel>> loadMoreComments(
      int episodeId, int page) async {
    try {
      final response = await remoteDataSource.loadMoreComments(episodeId, page);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
   Future<Either<Failure, CommentResponseModel>> getMyComments(
      int episodeId) async {
    try {
      final response = await remoteDataSource.getMyComments(episodeId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, CommentModel>> addComment({
    required int episodeId,
    required String content,
  }) async {
    try {
      final response = await remoteDataSource.addComment(
        episodeId: episodeId,
        content: content,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, CommentModel>> updateComment({
    required int commentId,
    required String content,
  }) async {
    try {
      final response = await remoteDataSource.updateComment(
        commentId: commentId,
        content: content,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, String>> deleteComment(
      int commentId,bool isTeacher) async {
    try {
      final response = await remoteDataSource.deleteComment(commentId,isTeacher);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, CommentModel>> addLike(
      int commentId) async {
    try {
      final response = await remoteDataSource.addLike(commentId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
  Future<Either<Failure, CommentModel>> removeLike(
      int commentId) async {
    try {
      final response = await remoteDataSource.removeLike(commentId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}