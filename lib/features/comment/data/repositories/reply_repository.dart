// reply_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/comment/data/datasources/reply_remote_data_source.dart';
import 'package:learning_management_system/features/comment/data/models/reply_model.dart';
import 'package:learning_management_system/features/comment/data/models/reply_reponse_model.dart';

class ReplyRepository {
  final ReplyRemoteDataSource remoteDataSource;

  ReplyRepository({required this.remoteDataSource});

  Future<Either<Failure, RepliesResponseModel>> getReplies(
      int commentId) async {
    try {
      final response = await remoteDataSource.getReplies(commentId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, ReplyResponseModel>> addReply({
    required int commentId,
    required String content,
  }) async {
    try {
      final response = await remoteDataSource.addReply(
        commentId: commentId,
        content: content,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, ReplyModel>> updateReply({
    required int replyId,
    required String content,
  }) async {
    try {
      final response = await remoteDataSource.updateReply(
        replyId: replyId,
        content: content,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, String>> deleteReply(
      int replyId,
      bool isTeacher
      ) async {
    try {
      final response = await remoteDataSource.deleteReply(replyId,isTeacher);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, ReplyResponseModel>> addLikeReply(
      int replyId) async {
    try {
      final response = await remoteDataSource.LikeReply(replyId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  
}