// features/statistics/data/datasources/statistics_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/statistics/data/models/statistics_resopnse_model.dart';

class StatisticsRemoteDataSource {
  final ApiConsumer api;

  StatisticsRemoteDataSource({required this.api});

  Future<StatisticsResponseModel> getStatistics() async {
    final accessToken = await SharedPrefHelper.getString('accessToken');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };

    final response = await api.get(
      EndPoints.statistics,
      options: Options(headers: headers),
    );

    return StatisticsResponseModel.fromJson(response);
  }
}