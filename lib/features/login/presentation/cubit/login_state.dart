
import 'package:learning_management_system/features/login/data/models/login_response_model.dart';

abstract class LoginState {}

final class LoginInitial extends LoginState {}


final class LoginLoading extends LoginState{}

final class LoginFailure extends LoginState{
  final String errMessage;
 

  LoginFailure({required this.errMessage});
}
final class LoginSuccessfully extends LoginState{
  final LoginResponseModel loginResponseModel;

  LoginSuccessfully({required this.loginResponseModel});
}

