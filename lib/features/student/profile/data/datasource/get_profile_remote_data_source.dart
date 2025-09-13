// features/profile/data/datasources/profile_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class GetProfileRemoteDataSource {
  final ApiConsumer api;

  GetProfileRemoteDataSource({required this.api});

  Future<AuthResponseModel> getProfile(int userId) async {
    final response = await api.get('${EndPoints.profile}/$userId');
    return AuthResponseModel.fromJson(response);
  }
  Future<AuthResponseModel> getUserProfile() async {
    final response = await api.get('${EndPoints.showMyProfile}',options: Options(extra: {
      'authRequired':true
    }));
    return AuthResponseModel.fromJson(response);
  }
}