import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

class StartQuizRemoteDataSource{
  ApiConsumer api;

  StartQuizRemoteDataSource({
    required this.api,
  });

  Future<QuizModel>startQuiz({required int quizId})async{

final accessToken = await SharedPrefHelper.getString('accessToken');

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    print(accessToken);
    final response = await api.post('${EndPoints.startQuiz}/$quizId',options: Options(headers: headers));
  
    return QuizModel.fromJson(response[ApiKey.data]);
  }

}
