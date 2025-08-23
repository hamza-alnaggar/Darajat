// features/levels/data/models/level_response_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';

class LevelResponseModel {
  final List<String> levels;

  LevelResponseModel({required this.levels});

  factory LevelResponseModel.fromJson(Map<String, dynamic> json) {
    return LevelResponseModel(
      levels: List<String>.from(json[ApiKey.data] ?? []),
    );
  }
}