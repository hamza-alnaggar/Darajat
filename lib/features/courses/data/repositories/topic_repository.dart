import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/topic_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';

class TopicRepository {
  final TopicRemoteDataSource remoteDataSource;

  TopicRepository({required this.remoteDataSource});

  Future<Either<Failure, TopicResponseModel>> getTopicsByCategory(
      int categoryId) async {
    try {
      final response = await remoteDataSource.getTopicsByCategory(categoryId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}