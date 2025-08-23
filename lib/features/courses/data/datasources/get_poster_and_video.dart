// features/topics/data/datasources/topic_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';

class GetPosterAndVideo {
  final ApiConsumer api;

  GetPosterAndVideo({required this.api});

  Future<String> (int courseId) async {

  final accessToken = 
  await SharedPrefHelper.getString('accessToken');

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };

  final response = await api.post(
    '${EndPoints.rateCourse}/$courseId',
    options: Options(headers: headers)
  );

  return response['message'];
}
}