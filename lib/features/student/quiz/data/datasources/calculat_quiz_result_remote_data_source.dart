import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/student/quiz/data/models/answer_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_result_model.dart';

class CalculatQuizResultRemoteDataSource {

  ApiConsumer api;

  CalculatQuizResultRemoteDataSource({
    required this.api,
  });
  
  Future<QuizResultModel> calculateQuizResult({
    required int quizId,
    required List<AnswerModel> answers,
  }) async {
    final accessToken = await SharedPrefHelper.getString('accessToken');
    
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

   

    final response = await api.put(
      '${EndPoints.calculateQuizResult}/$quizId', // Add to EndPoints
      data: answers.map((answer) => answer.toJson()).toList(),
      options: Options(headers: headers),
    );
    
    return QuizResultModel.fromJson(response);
  }
}
