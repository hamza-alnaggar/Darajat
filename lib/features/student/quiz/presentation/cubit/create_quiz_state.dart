

import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

abstract class QuizCreationState {}

class QuizCreationInitial extends QuizCreationState {}
class QuizCreationLoading extends QuizCreationState {}
class QuizCreationSuccess extends QuizCreationState {
  final String message;
  QuizCreationSuccess({required this.message});
}
class QuizCreationFailure extends QuizCreationState {
  final String errMessage;
  QuizCreationFailure({required this.errMessage});
}