// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/student/quiz/data/models/sub_models/question_sub_models.dart';

class QuizModel {
  int quizId;
  int numOfQuestions;
  List<QuestionSubModels>questions;

  QuizModel({
    required this.quizId,
    required this.numOfQuestions,
    required this.questions,
    
  });

 factory QuizModel.fromJson(Map json){
   final questionList = (json[ApiKey.questions] as List<dynamic>)
        .map((question) => QuestionSubModels.fromJson(question))
        .toList();
    return QuizModel(quizId: json['id'],numOfQuestions: json[ApiKey.numOfQuestions], questions:questionList, );
  }
  
}
class QuizResponseModel
{
  final QuizModel quiz;
  final String message;

  QuizResponseModel({required this.quiz, required this.message});
  
factory QuizResponseModel.fromJson(Map json){
   
    return QuizResponseModel(quiz:QuizModel.fromJson(json['data']) ,message: json['message']) ;
  }

}
