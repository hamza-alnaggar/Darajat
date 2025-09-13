// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';

class CreateEpisodeBodyModel {
  String title;
  File ?videoFile;
  File ?imageFile;
  File ?pdfFile;

  CreateEpisodeBodyModel({
    required this.title,
    required this.videoFile,
    required this.imageFile,
    required this.pdfFile,
  });

  toJson(){
    print('image $imageFile');
    print('video $videoFile');
    return {
      'title': title,
      'video_url':videoFile != null? MultipartFile.fromFileSync(videoFile!.path):null,
      'image_url':imageFile != null? MultipartFile.fromFileSync(imageFile!.path):null,
     if(pdfFile!=null) 'file_url': MultipartFile.fromFileSync(pdfFile!.path),
    };
  }
  
}
