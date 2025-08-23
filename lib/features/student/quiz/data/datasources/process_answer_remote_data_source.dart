import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/student/quiz/data/models/process_answer_model.dart';

class ProcessAnswerRemoteDataSource {

   ApiConsumer api;

  ProcessAnswerRemoteDataSource({
    required this.api,
  });

  
  Future<ProcessAnswerModel> processAnswer({
    required int quizId,
    required int questionNumber,
    required String answer,
  }) async {
    final accessToken = await SharedPrefHelper.getString('accessToken');
    
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = {
      'quiz_id': quizId,
      'question_number': questionNumber,
      'answer': answer,
    };

    final response = await api.post(
      EndPoints.processAnswer, 
      options: Options(headers: headers),
      data: body,
    );
    
    return ProcessAnswerModel.fromJson(response[ApiKey.data]);
  }
}
