// features/badges/data/datasources/badges_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/badges/data/models/badges_response_model.dart';

class BadgesRemoteDataSource {
  final ApiConsumer api;

  BadgesRemoteDataSource({required this.api});

  Future<BadgesResponseModel> getBadges() async {
    final accessToken = await SharedPrefHelper.getString('accessToken');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };

    final response = await api.get(
      EndPoints.badges,
      options: Options(headers: headers),
    );

    return BadgesResponseModel.fromJson(response);
  }
}