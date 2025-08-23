// process_answer_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';

class ProcessAnswerModel {
  final bool isCorrect;
  final String rightAnswer;
  final String? explanation;

  ProcessAnswerModel({
    required this.isCorrect,
    required this.rightAnswer,
    this.explanation,
  });

  factory ProcessAnswerModel.fromJson(Map<String, dynamic> json) {
    return ProcessAnswerModel(
      isCorrect: json[ApiKey.isCorrect],
      rightAnswer: json[ApiKey.rightAnswer],
      explanation: json[ApiKey.explanation],
    );
  }
}