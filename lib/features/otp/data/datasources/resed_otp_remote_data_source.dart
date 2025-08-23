import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';

class ResedOtpRemoteDataSource {
  ApiConsumer api;

  ResedOtpRemoteDataSource({
    required this.api,
  });

  Future<String>resendOtp({required String email})async{
       

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await api.post(EndPoints.resendOtp,data: {
      'email':email
    },options: Options(headers: headers));
    return response[ApiKey.message];
  }

}
