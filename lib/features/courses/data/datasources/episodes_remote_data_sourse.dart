// features/episodes/data/datasources/episodes_remote_data_source.dart
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';

class EpisodesRemoteDataSource {
  final ApiConsumer api;

  EpisodesRemoteDataSource({required this.api});

  Future<EpisodeResponseModel> getEpisodes(
    int courseId,
    bool isStudent,
    bool isCopy,
  ) async {
    final response = await api.get(
      '${isStudent ? EndPoints.getEpisodesForStudent : EndPoints.getEpisodesFortetcher}/$courseId',
      queryParameters: {'copy': isCopy},
      options: Options(extra: {'authRequired': true}),
    );
    return EpisodeResponseModel.fromJson(response['data'], isStudent);
  }

  Future<EpisodeResponse> showEpisode(int episodeId, bool isStudent) async {
    final response = await api.get(
      '${isStudent ? EndPoints.showEpisodesForStudent : EndPoints.showEpisodesFortetcher}/$episodeId',
      options: Options(extra: {'authRequired': true}),
    );
    return EpisodeResponse.fromJson(response);
  }

  Future<void> finishEpisode(int episodeId) async {
      await api.post(
      '${EndPoints.finishEpisode}/$episodeId',
      options: Options(extra: {'authRequired': true}),
    );
  
  }

  Future<EpisodeResponse> LikeEpisode(int episodeId) async {
    final response = await api.post(
      '${EndPoints.LikeEpisode}/$episodeId',
      options: Options(extra: {'authRequired': true}),
    );
    return EpisodeResponse.fromJson(response);
  }

  Future<Uint8List> getEpisodePoster(int episodeId, bool isCopy) async {
    final response = await api.get(
      '${EndPoints.getPoster}/$episodeId',
      queryParameters: {'copy': isCopy},
      options: Options(
        responseType: ResponseType.bytes,
        extra: {'authRequired': true},
      ),
    );
    return Uint8List.fromList(response);
  }

  Future<Uint8List> getEpisodePdf(int episodeId, bool isCopy) async {
    final response = await api.get(
      '${EndPoints.getPdf}/$episodeId',
      queryParameters: {'copy': isCopy},
      options: Options(
        responseType: ResponseType.bytes,
        extra: {'authRequired': true},
      ),
    );
    return Uint8List.fromList(response);
  }

  Future<String> downloadFile(int episodeId, String path) async {
                      final token = await SharedPrefHelper.getString('accessToken');

    final response = await api.download(
      '${EndPoints.downloadFile}/$episodeId',
      savePath: path,
      options: Options(
        responseType: ResponseType.bytes,
        extra: {'authRequired': true},
      ),
    );
    return path;
  }

  Future<Stream<Uint8List>> getEpisodeVideo(int episodeId, bool isCopy) async {

    final response = await api.get(
      '${EndPoints.getVideo}/$episodeId',
      queryParameters: {'copy': isCopy},
      options: Options(
        responseType: ResponseType.stream,
        extra: {'authRequired': true},
      ),
    );
    return response.stream;
  }
}
