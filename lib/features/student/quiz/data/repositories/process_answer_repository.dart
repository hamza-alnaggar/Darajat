import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/quiz/data/datasources/process_answer_remote_data_source.dart';
import 'package:learning_management_system/features/student/quiz/data/models/process_answer_model.dart';

class ProcessAnswerRepository {

   final ProcessAnswerRemoteDataSource processAnswerRemoteDataSource;

  ProcessAnswerRepository({
    required this.processAnswerRemoteDataSource,
  });

  Future<Either<Failure, ProcessAnswerModel>> processAnswer({
    required int quizId,
    required int questionNumber,
    required String answer,
  }) async {
    try {
      final response = await processAnswerRemoteDataSource.processAnswer(
        quizId: quizId,
        questionNumber: questionNumber,
        answer: answer,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}

