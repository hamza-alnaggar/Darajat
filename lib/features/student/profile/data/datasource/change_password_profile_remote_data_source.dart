// features/profile/data/datasources/profile_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/student/profile/data/models/change_password_profile_body.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class ChangePasswordProfileRemoteDataSource {
  final ApiConsumer api;

  ChangePasswordProfileRemoteDataSource({required this.api});

  Future<AuthResponseModel> changePasswordInProfile(ChangePasswordProfileBody body) async {
    final response = await api.post(EndPoints.changePassword,isFormData: true,data: body.toJson(),options: Options( headers: {
      'Change-Type': 'changed',
    },extra: {
        'authRequired': true, // If this endpoint requires auth
      },));
    return AuthResponseModel.fromJson(response);
  }
}