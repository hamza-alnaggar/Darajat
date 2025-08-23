// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';

class CreateEpisodeBodyModel {
  String title;
  int episodeNumber;
  File videoFile;
  File imageFile;
  File ?pdfFile;

  CreateEpisodeBodyModel({
    required this.title,
    required this.episodeNumber,
    required this.videoFile,
    required this.imageFile,
    required this.pdfFile,
  });

  toJson(){
    return {
      'title': title,
      'episode_number':episodeNumber,
      'video_url': MultipartFile.fromFileSync(videoFile.path),
      'image_url' :MultipartFile.fromFileSync(imageFile.path),
      'file_url' :MultipartFile.fromFileSync(pdfFile!.path),
    };
  }
  
}
