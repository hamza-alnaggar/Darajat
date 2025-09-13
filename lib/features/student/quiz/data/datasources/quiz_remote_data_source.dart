// quiz_creation_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_create_body.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

class QuizCreationRemoteDataSource {
  final ApiConsumer api;

  QuizCreationRemoteDataSource({required this.api});

  Future<QuizResponseModel> createQuiz({
    required QuizCreateBody request,
    required int episodeId,
    required bool isCopy
  }) async {

    final response = await api.post(
    isCopy? '${EndPoints.createQuiz}/$episodeId/copy': '${EndPoints.createQuiz}/$episodeId',
    options: Options(extra: {"authRequired":true}),
      data: request.toJson(),
    );
    
    return QuizResponseModel.fromJson(response);
  }
  Future<String> updateQuiz({
    required QuizCreateBody request,
    required int episodeId,
    required bool isCopy

  }) async {

    final response = await api.put(
     isCopy?'${EndPoints.updateQuiz}/$episodeId/copy': '${EndPoints.updateQuiz}/$episodeId',
      options: Options(extra: {"authRequired":true}),
      data: request.toJson(),
    );
    
    return response['message'] ;
  }
  Future<String> deleteQuiz({
    required bool isCooy,
    required int episodeId

  }) async {

    final response = await api.delete(
      isCooy? '${EndPoints.deleteQuiz}/$episodeId/copy': '${EndPoints.deleteQuiz}/$episodeId',
      options: Options(extra: {"authRequired":true}),
    );
    
    return response['message'];
  }
}