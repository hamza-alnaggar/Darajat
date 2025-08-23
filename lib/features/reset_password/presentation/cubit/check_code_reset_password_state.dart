// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/features/reset_password/data/models/check_code_reset_password_response.dart';

abstract class CheckCodeResetPasswordState {}

class CheckCodeInitial extends CheckCodeResetPasswordState {}
class CheckCodeLoading extends CheckCodeResetPasswordState {}

class CheckCodeSuccessfully extends CheckCodeResetPasswordState {
  final CheckCodeResetPasswordResponse checkCode;

  CheckCodeSuccessfully({
    required this.checkCode,
  });
}

class CheckCodeFailure extends CheckCodeResetPasswordState {
  final String errMessage;
  CheckCodeFailure({required this.errMessage});
}

