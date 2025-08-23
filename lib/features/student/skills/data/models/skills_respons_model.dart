// features/skills/data/models/skill_response_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/student/skills/data/models/sub_models/skills_sub_models.dart';

class SkillResponseModel {
  final List<SkillSubModel> skills;

  SkillResponseModel({required this.skills});

  factory SkillResponseModel.fromJson(Map<String, dynamic> json) {
    final skillsList = (json[ApiKey.data] as List<dynamic>)
        .map((skill) => SkillSubModel.fromJson(skill))
        .toList();
    return SkillResponseModel(skills: skillsList);
  }
}