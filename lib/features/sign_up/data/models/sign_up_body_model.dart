// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:learning_management_system/core/databases/api/end_points.dart';

class SignUpBodyModel {
  String lastName;
  String fistName;
  String email;
  String password;
  String passwordConfirm;
  int ?countryId;
  int ?languageId;

  SignUpBodyModel({
    required this.lastName,
    required this.fistName,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.countryId,
    required this.languageId
  });

  Map<String, dynamic> toJson() {
  return {
    ApiKey.firstName: fistName, 
    ApiKey.lastName: lastName,
    ApiKey.email: email,
    ApiKey.password: password,
    ApiKey.passwordConfirm: passwordConfirm,
    ApiKey.countryId: countryId,
    ApiKey.languageId: languageId,
  };
}
  
}
