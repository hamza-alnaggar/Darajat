// features/profile/data/datasources/profile_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/student/profile/data/models/sub_models/update_profile_body_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class UpdateProfileRemoteDataSource {
  final ApiConsumer api;

  UpdateProfileRemoteDataSource({required this.api});

  Future<AuthResponseModel> updateProfile(UpdateProfileBodySubModel body) async {

    final accessToken = await SharedPrefHelper.getString('accessToken');

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await api.post(EndPoints.updateProfile,data: body.toJson(),options: Options(headers: headers));
    return AuthResponseModel.fromJson(response);
  }
}