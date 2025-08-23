// features/skills/data/datasources/skill_remote_data_source.dart
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/student/skills/data/models/skills_respons_model.dart';

class GetSkillsRemoteDataSource {
  final ApiConsumer api;

  GetSkillsRemoteDataSource({required this.api});

  Future<SkillResponseModel> getSkills() async {
    final response = await api.get(EndPoints.skills);
    return SkillResponseModel.fromJson(response);
  }
}