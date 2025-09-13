// features/statistics/data/datasources/statistics_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/statistics/data/models/statistics_resopnse_model.dart';

class StatisticsRemoteDataSource {
  final ApiConsumer api;

  StatisticsRemoteDataSource({required this.api});

  Future<StatisticsResponseModel> getStatistics(bool isEnthusiasm) async {

    final response = await api.get(
     isEnthusiasm?EndPoints.statisticsEnthusiasm : EndPoints.statistics,
      options: Options(extra: {
       "authRequired" :true
      }),
    );

    return StatisticsResponseModel.fromJson(response);
  }
}