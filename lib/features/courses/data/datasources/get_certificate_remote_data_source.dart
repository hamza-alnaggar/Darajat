// features/categories/data/datasources/category_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';

class GetCertificateRemoteDataSource {
  final ApiConsumer api;

  GetCertificateRemoteDataSource({required this.api});

  Future<String> getCertificate(int courseId) async {
    final response = await api.post('${EndPoints.getCertificate}/$courseId',options: Options(extra: {
      'authRequired':true
    }));
    return response['credential_url'];
  }
}