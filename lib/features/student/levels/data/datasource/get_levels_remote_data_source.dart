// features/levels/data/datasources/level_remote_data_source.dart
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/student/levels/data/models/levels_respons_model.dart';

class GetLevelsRemoteDataSource {
  final ApiConsumer api;

  GetLevelsRemoteDataSource({required this.api});

  Future<LevelResponseModel> getLevels() async {
    final response = await api.get(EndPoints.levels);
    return LevelResponseModel.fromJson(response);
  }
}