// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/user_sub_model.dart';

class AuthResponseModel {
  String message;
  UserSubModel user;

  AuthResponseModel({
    required this.message,
    required this.user,
  });

  AuthResponseModel copyWith({

    UserSubModel? user,
  }) {
    return AuthResponseModel(
      message: message,
      user: user ?? this.user,
    );
  }


  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(message: json[ApiKey.message], user:UserSubModel.fromJson(json[ApiKey.data]));
  }


  
}
