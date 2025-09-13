// quiz_result_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';

class QuizResultModel {
  final String mark;
  final String percentageMark;
  final bool success;
  String message;
  QuizResultModel({
    required this.mark,
    required this.percentageMark,
    required this.message,
    required this.success
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      mark: json[ApiKey.data][ApiKey.mark],
      success:json[ApiKey.data]['success'],
      percentageMark: json[ApiKey.data][ApiKey.percentageMark],
      message: json[ApiKey.message],
    );
  }
}