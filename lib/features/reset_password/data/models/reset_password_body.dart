// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:learning_management_system/core/databases/api/end_points.dart';

class ResetPasswordBody {
  String code ;
  String password;
  String passwordConfirm;
  

  ResetPasswordBody({
    required this.code,
    required this.password,
    required this.passwordConfirm
  });

  Map<String, dynamic> toJson() {
  return {
    ApiKey.code:code,
    ApiKey.password:password,
    ApiKey.passwordConfirm:passwordConfirm,
  };
}
  
}
