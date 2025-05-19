// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:learning_management_system/core/databases/api/end_points.dart';

class LoginBodyModel {
  
  String email;
  String password;


  LoginBodyModel({
   
    required this.email,
    required this.password,
    
  });

  Map<String, dynamic> toJson() {
  return {
    
    ApiKey.email: email,
    ApiKey.password: password,
    
  };
}
  
}
