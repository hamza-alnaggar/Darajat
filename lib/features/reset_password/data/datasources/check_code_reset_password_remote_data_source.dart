import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/reset_password/data/models/check_code_reset_password_response.dart';

class CheckCodeResetPasswordRemoteDataSource {
  ApiConsumer api;

  CheckCodeResetPasswordRemoteDataSource({
    required this.api,
  });

  Future<CheckCodeResetPasswordResponse>checkCodeResetPassword(String ?code)async{

      final headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

    final response = await api.post(EndPoints.checkCodeResetPassword,data: {
      'code':code
    },options: Options(headers: headers));
  
    return CheckCodeResetPasswordResponse.fromJson(response);
  }

}
