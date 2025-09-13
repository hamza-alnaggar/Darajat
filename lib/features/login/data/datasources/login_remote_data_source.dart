import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/login/data/models/login_body_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class LoginRemoteDataSource{
  ApiConsumer api;

  LoginRemoteDataSource({
    required this.api,
  });

  Future<AuthResponseModel>login({required LoginBodyModel loginBodyModel})async{

  
    final response = await api.post(EndPoints.login,data: loginBodyModel.toJson());
  
    return AuthResponseModel.fromJson(response);
  }
  Future<LoginFromGoogleModel>loginWithGoogle({required String token})async{

 
    final response = await api.post('${EndPoints.login}/google',data: {
      'id_token' : token
    });
  
    return LoginFromGoogleModel.fromJson(response['data']);
  }

}

class LoginFromGoogleModel{
 final String token;
  final int id;

  LoginFromGoogleModel({required this.token, required this.id});

  factory LoginFromGoogleModel.fromJson(Map<String, dynamic> json) {
    return LoginFromGoogleModel(id: json[ApiKey.id], token:json['token']);
  }
}
