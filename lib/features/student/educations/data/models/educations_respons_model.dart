// features/education/data/models/education_response_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';

class EducationResponseModel {
  final List<String> educations;

  EducationResponseModel({required this.educations});

  factory EducationResponseModel.fromJson(Map<String, dynamic> json) {
    return EducationResponseModel(
      educations: List<String>.from(json[ApiKey.data] ?? []),
    );
  }
}