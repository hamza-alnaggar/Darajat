import 'dart:io';

import 'package:dio/dio.dart';

class CreateCourseRequestModel {
  final int topicId;
  final int languageId;
  final String title;
  final String description;
  final File image;
  final String difficultyLevel;
  final double price;
  final String? hasCertificate;

  CreateCourseRequestModel({
    required this.topicId,
    required this.languageId,
    required this.title,
    required this.description,
    required this.image,
    required this.difficultyLevel,
    required this.price,
    this.hasCertificate,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic_id': topicId,
      'language_id': languageId,
      'title': title,
      'description': description,
      'difficulty_level': difficultyLevel,
      'image_url':MultipartFile.fromFileSync(image.path),
      'price': price,
      if (hasCertificate != null) 'has_certificate': hasCertificate,
    };
  }

}