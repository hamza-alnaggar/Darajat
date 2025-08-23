
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

abstract class LoginState {}

final class LoginInitial extends LoginState {}


final class LoginLoading extends LoginState{}

final class LoginFailure extends LoginState{
  final String errMessage;
 

  LoginFailure({required this.errMessage});
}
final class LoginSuccessfully extends LoginState{
  final AuthResponseModel loginResponseModel;

  LoginSuccessfully({required this.loginResponseModel});
}

