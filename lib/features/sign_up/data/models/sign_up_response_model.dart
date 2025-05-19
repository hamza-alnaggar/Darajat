// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/user_sub_model.dart';

class SignUpResponseModel {
  String message;
  UserSubModel user;
  String accessToken;

  SignUpResponseModel({
    required this.message,
    required this.user,
    required this.accessToken,
  });


  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(message: json[ApiKey.message], user:UserSubModel.fromJson(json[ApiKey.user]) , accessToken: json[ApiKey.accessToken]);
  }
  
}
