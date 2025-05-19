// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/user_sub_model.dart';

class LoginResponseModel {
  String message;
  UserSubModel user;
  String accessToken;

  LoginResponseModel({
    required this.message,
    required this.user,
    required this.accessToken,
  });


  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(message: json[ApiKey.message], user:UserSubModel.fromJson(json[ApiKey.user]) , accessToken: json[ApiKey.accessToken]);
  }
  
}
