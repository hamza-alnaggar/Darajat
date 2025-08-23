// features/episodes/data/datasources/episodes_remote_data_source.dart
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';

class EpisodesRemoteDataSource {
  final ApiConsumer api;

  EpisodesRemoteDataSource({required this.api});

  Future<EpisodeResponseModel> getEpisodes(int courseId, bool isStudent,bool isCopy) async {

    final response = await api.get(
    '${isStudent? EndPoints.getEpisodesForStudent : EndPoints.getEpisodesFortetcher}/$courseId',
    queryParameters:{
        'copy':isCopy
      },
      options: Options(
        extra: {'authRequired': true}, 
      )
    );
    return EpisodeResponseModel.fromJson(response['data'],isStudent);
  }

  Future<EpisodeModel> showEpisode(int episodeId,bool isStudent) async {
  
    final response = await api.get(
      '${isStudent? EndPoints.showEpisodesForStudent : EndPoints.showEpisodesFortetcher}/$episodeId',
      options: Options(
        extra: {'authRequired': true}, 
      )
    );
    return EpisodeModel.fromJson(response['data']);
  }
  Future<String> finishEpisode(int episodeId) async {
  
    final response = await api.post(
      '${EndPoints.finishEpisode}/$episodeId',
      options: Options(
        extra: {'authRequired': true}, 
      )
    );
    return response['message'];
  }
  Future<String> addLikeToEpisode(int episodeId) async {
  
    final response = await api.post(
      '${EndPoints.addLikeToEpisode}/$episodeId',
      options: Options(
        extra: {'authRequired': true}, 
      )
    );
    return response['message'];
  }
  Future<String> removeLikeFromEpisode(int episodeId) async {
  
    final response = await api.delete(
      '${EndPoints.removeLikeFromEpisode}/$episodeId',
      options: Options(
        extra: {'authRequired': true}, 
      )
    );
    return response['message'];
  }

  Future<Uint8List> getEpisodePoster(int episodeId,bool isCopy) async {
  
    final response = await api.get(
      '${EndPoints.getPoster}/$episodeId',queryParameters:{
        'copy':isCopy
      },
      options: Options(responseType: ResponseType.bytes,extra: {'authRequired': true}, ),
      
    );
    return Uint8List.fromList(response);
  }
  Future<Stream<Uint8List>> getEpisodeVideo(int episodeId,bool isCopy) async {
  final response = await api.get(
    '${EndPoints.getVideo}/$episodeId',
    queryParameters:{
        'copy':isCopy
      },
    options: Options(
      responseType: ResponseType.stream,
      extra: {'authRequired': true},
    ),
  );
  return response.stream; 
}


}