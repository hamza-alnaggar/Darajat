

import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

abstract class QuizCreationState {}

class QuizCreationInitial extends QuizCreationState {}
class QuizCreationLoading extends QuizCreationState {}
class QuizCreationSuccess extends QuizCreationState {
  final QuizModel response;
  QuizCreationSuccess({required this.response});
}
class QuizCreationFailure extends QuizCreationState {
  final String errMessage;
  QuizCreationFailure({required this.errMessage});
}