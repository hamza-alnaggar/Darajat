import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/login/data/models/login_body_model.dart';
import 'package:learning_management_system/features/login/data/models/login_response_model.dart';

class LoginRemoteDataSource{
  ApiConsumer api;

  LoginRemoteDataSource({
    required this.api,
  });

  Future<LoginResponseModel>login({required LoginBodyModel loginBodyModel})async{

  final headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};
    final response = await api.post(EndPoints.login,data: loginBodyModel.toJson(),options: Options(headers: headers));
  
    return LoginResponseModel.fromJson(response);
  }

}
