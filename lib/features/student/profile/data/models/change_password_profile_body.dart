// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';

class ChangePasswordProfileBody {
  String oldPassword;
  String newPassword;
  String newPasswordConfirmation;


  ChangePasswordProfileBody({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    ApiKey.oldPassword: oldPassword,
    ApiKey.newPassword: newPassword,
    ApiKey.newPasswordConfirmation: newPasswordConfirmation,
  };


}
