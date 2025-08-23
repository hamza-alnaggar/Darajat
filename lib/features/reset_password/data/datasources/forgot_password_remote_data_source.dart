import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';

class ForgotPasswordRemoteDataSource {
  ApiConsumer api;

  ForgotPasswordRemoteDataSource({
    required this.api,
  });

  Future<String>forgotPassword(String email)async{

  final headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};
    final response = await api.post(EndPoints.forgotPassword,data: {
      'email':email
    },options: Options(headers: headers));
  
    return response[ApiKey.message];
  }

}
