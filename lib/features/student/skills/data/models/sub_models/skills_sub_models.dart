// features/skills/data/models/skill_sub_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';

class SkillSubModel {
  final int id;
  final String title;

  SkillSubModel({required this.id, required this.title});

  factory SkillSubModel.fromJson(Map<String, dynamic> json) {
    return SkillSubModel(
      id: json['id'],
      title: json['title'],
    );
  }
  toJson(){
    return {
      ApiKey.skillId:id,
    };
  }

}