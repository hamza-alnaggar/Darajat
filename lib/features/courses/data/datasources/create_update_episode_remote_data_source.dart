// features/topics/data/datasources/topic_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/create_episode_body_model.dart';

class CreateUpdateEpisodeRemoteDataSource {
  final ApiConsumer api;

  CreateUpdateEpisodeRemoteDataSource({required this.api});

  Future<String> createEpisode(int courseId,CreateEpisodeBodyModel body,bool isCopy) async {


   
  final response = await api.post(
   isCopy?'${EndPoints.createEpisode}/$courseId/copy' : '${EndPoints.createEpisode}/$courseId',
    data: body.toJson(),
    isFormData: true,
    options: Options(extra: {'authRequired': true},)
  );

  return response['message'];
}
Future<String> deletePdf(int episodeId,bool isCopy) async {
  
    final response = await api.delete(
      '${EndPoints.deletePdf}/$episodeId',queryParameters:{
        'copy':isCopy
      },
      options: Options(responseType: ResponseType.bytes,extra: {'authRequired': true}, ),
      
    );
    return 'Episode deleted Successfully';
  }
Future<String> deleteEpisode(int courseId,bool isCopy) async {
    final response = await api.delete(
    isCopy? '${EndPoints.deleteEpisode}/$courseId/copy': '${EndPoints.deleteEpisode}/$courseId',
      options: Options(extra: {'authRequired': true},)
    );
    return response['message'];
  }

  Future<String> updateEpisode(int episodeId,CreateEpisodeBodyModel body,bool isCopy) async {
  final response = await api.post(
  isCopy?'${EndPoints.updateEpisode}/$episodeId/copy' :  '${EndPoints.updateEpisode}/$episodeId',
    data: body.toJson(),
    isFormData: true,
    options: Options(
            headers: {
     // 'X-HTTP-Method-Override':'PUT'
    },extra: {'authRequired': true
    },)
  );

  return response['message'];
}
}