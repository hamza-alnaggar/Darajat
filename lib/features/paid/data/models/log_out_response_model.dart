

import 'package:learning_management_system/core/databases/api/end_points.dart';

class LogOutResponseModel {
  String message;

  LogOutResponseModel({
    required this.message,
  });

  factory LogOutResponseModel.fromJson(Map<String,dynamic>json){
    return LogOutResponseModel(message: json[ApiKey.message]);
  }
}
