// features/profile/data/datasources/profile_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';

class PromoteStudentRemoteDataSourse {
  final ApiConsumer api;

  PromoteStudentRemoteDataSourse({required this.api});

  Future<String> promoteStudent() async {
    final response = await api.post(EndPoints.promoteStudent,options: Options(extra: {
        'authRequired': true, // If this endpoint requires auth
      },));
    return response['message'];
  }
}