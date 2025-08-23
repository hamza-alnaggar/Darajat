// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';

class QuestionSubModels {
  int ?questionId;
  int questionNumber;
  String content;
  String answerA;
  String answerB;
  String answerC;
  String answerD;
  String ?explanation;
  String ?rightAnswer ;

  QuestionSubModels({
    this.questionId,
    required this.questionNumber,
    required this.content,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.explanation,
    this.rightAnswer
  });

  factory QuestionSubModels.fromJson(Map json){
    return QuestionSubModels(explanation:json['explanation'],questionId: json[ApiKey.questionId], questionNumber: json[ApiKey.questionNumber], rightAnswer: json['right_answer'],content: json[ApiKey.content], answerA: json[ApiKey.answerA], answerB: json[ApiKey.answerB], answerC: json[ApiKey.answerC], answerD: json[ApiKey.answerD]);
  }


}
