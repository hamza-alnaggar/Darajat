import 'package:learning_management_system/core/databases/api/end_points.dart';

class CheckCodeResetPasswordResponse {
  String code;
  String message ;

  CheckCodeResetPasswordResponse({
    required this.code,
    required this.message,
  });

  factory CheckCodeResetPasswordResponse.fromJson(Map<String,dynamic>json){
    return CheckCodeResetPasswordResponse(code: json[ApiKey.data][ApiKey.code], message: json[ApiKey.message]);
  }

}
