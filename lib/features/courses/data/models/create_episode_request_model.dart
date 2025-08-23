import 'dart:io';

import 'package:dio/dio.dart';

class CreateEpisodeRequestModel {
  final String title;
  final String episodeNumber;
  final File videoFile;
  final File imageFile;

  CreateEpisodeRequestModel({
    required this.title,
    required this.episodeNumber,
    required this.videoFile,
    required this.imageFile,
  });

  Future<Map<String, dynamic>> toJson() async {
    return {
      'title': title,
      'episode_number': episodeNumber,
      'video_url': MultipartFile.fromFileSync(videoFile.path,),
      'image_url': MultipartFile.fromFileSync(imageFile.path,),
    };
  }
}
