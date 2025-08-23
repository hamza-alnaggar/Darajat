import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';

class VerifyOtpRemoteDataSource {
  ApiConsumer api;

  VerifyOtpRemoteDataSource({
    required this.api,
  });

  Future<String>verfiyOtp({required String ?otp,required String email})async{

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await api.post(EndPoints.verfiyOtp,data: {
      'otp_code':otp,
      'email':email
    },
    options: Options(headers: headers));
  
    return response[ApiKey.data][ApiKey.token];
  }

}
