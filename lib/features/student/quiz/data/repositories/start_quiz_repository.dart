import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/quiz/data/datasources/start_quiz_remote_data_source.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

class StartQuizRepository {

  final StartQuizRemoteDataSource startQuizRemoteDataSource;

  StartQuizRepository({
    required this.startQuizRemoteDataSource,
  });

Future<Either<Failure, QuizModel>> startQuiz({
  required int quizId,
}) async {
  try {
    final response = await startQuizRemoteDataSource.startQuiz(
      quizId: quizId
    );
    return Right(response);
  } on ServerException catch (e) {
    return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

