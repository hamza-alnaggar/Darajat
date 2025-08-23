// quiz_creation_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';

class QuizCreateBody {
  final int episodeId;
  final int numOfQuestions;
  final List<QuestionCreationModel> questions;

  QuizCreateBody({
    required this.episodeId,
    required this.numOfQuestions,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKey.episodeId: episodeId,
      ApiKey.numOfQuestions: numOfQuestions,
      ApiKey.questions: questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionCreationModel {
  final int questionNumber;
  final String content;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final String rightAnswer;
  final String? explanation;

  QuestionCreationModel({
    required this.questionNumber,
    required this.content,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.rightAnswer,
    this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKey.questionNumber: questionNumber,
      ApiKey.content: content,
      ApiKey.answerA: answerA,
      ApiKey.answerB: answerB,
      ApiKey.answerC: answerC,
      ApiKey.answerD: answerD,
      ApiKey.rightAnswer: rightAnswer,
      if (explanation != null) ApiKey.explanation: explanation,
    };
  }
}

