import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/quiz/data/datasources/calculat_quiz_result_remote_data_source.dart';
import 'package:learning_management_system/features/student/quiz/data/models/answer_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_result_model.dart';

class CalculatQuizResultRepository {

  final CalculatQuizResultRemoteDataSource calculatQuizResultRemoteDataSource;

  CalculatQuizResultRepository({
    required this.calculatQuizResultRemoteDataSource,
  });

    Future<Either<Failure, QuizResultModel>> calculateQuizResult({
    required int quizId,
    required List<AnswerModel> answers,
  }) async {
    try {
      final response = await calculatQuizResultRemoteDataSource.calculateQuizResult(
        quizId: quizId,
        answers: answers,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}


