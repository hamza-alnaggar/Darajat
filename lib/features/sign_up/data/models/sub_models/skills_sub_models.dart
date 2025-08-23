import 'package:learning_management_system/core/databases/api/end_points.dart';

class SkillsBodySubModels {
  final int skillId;

  SkillsBodySubModels({required this.skillId});

  factory SkillsBodySubModels.fromJson(Map<String, dynamic> json) {
    return SkillsBodySubModels(skillId:json[ApiKey.skillId]  );
  }

  Map<String, dynamic> toJson() => {
    ApiKey.skillId: skillId,
  };
}