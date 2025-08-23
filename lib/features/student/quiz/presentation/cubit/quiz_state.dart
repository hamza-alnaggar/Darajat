
import 'package:learning_management_system/features/student/quiz/data/models/process_answer_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_result_model.dart';

abstract class QuizState {}

final class QuizInitial extends QuizState {}


final class QuizLoading extends QuizState{}

final class QuizFailure extends QuizState{
  final String errMessage;
 

  QuizFailure({required this.errMessage});
}
final class QuizSuccessfully extends QuizState{
  final QuizModel quizModel;

  QuizSuccessfully({required this.quizModel});
}
final class ProcessAnswerLoading extends QuizState{}

final class ProcessAnswerFailure extends QuizState{
  final String errMessage;
 

  ProcessAnswerFailure({required this.errMessage});
}
final class ProcessAnswerSuccessfully extends QuizState{
  final ProcessAnswerModel answerModel;

  ProcessAnswerSuccessfully({required this.answerModel});
}

final class CalculateQuizResultLoading extends QuizState{}

final class CalculateQuizResultFailure extends QuizState{
  final String errMessage;


  CalculateQuizResultFailure({required this.errMessage});
}
final class CalculateQuizResultSuccessfully extends QuizState{
  final QuizResultModel quizResultModel;

  CalculateQuizResultSuccessfully({required this.quizResultModel});
}

