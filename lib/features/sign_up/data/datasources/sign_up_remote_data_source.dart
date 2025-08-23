import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sign_up_body_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class SignUpRemoteDataSource {
  ApiConsumer api;

  SignUpRemoteDataSource({
    required this.api,
  });

  Future<AuthResponseModel>signup({required SignUpBodyModel signUpBodyModel})async{

    final headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

    final response = await api.post(EndPoints.register,data: signUpBodyModel.toJson(),options:Options(headers: headers));
  
    return AuthResponseModel.fromJson(response);
  }

}
