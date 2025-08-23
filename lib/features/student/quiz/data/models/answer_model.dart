// answer_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';

class AnswerModel {
  final int questionId;
  final String answer;

  AnswerModel({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKey.questionId: questionId,
      ApiKey.answer: answer,
    };
  }
}