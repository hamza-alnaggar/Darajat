import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/reset_password/data/models/reset_password_body.dart';

class ResetPasswordRemoteDataSource {
  ApiConsumer api;

  ResetPasswordRemoteDataSource({
    required this.api,
  });

  Future<String>resetPassword({required ResetPasswordBody resetPasswordBody})async{

    final headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

    final response = await api.post(EndPoints.resetPassword,data: resetPasswordBody.toJson(),options:Options(headers: headers));
  
    return response[ApiKey.message];
  }

}
