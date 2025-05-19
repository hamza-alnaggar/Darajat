
import 'package:learning_management_system/features/sign_up/data/models/sign_up_response_model.dart';

abstract class SignUpState {}

final class SignUpInitial extends SignUpState {}


final class SignUpLoading extends SignUpState{}

final class SignUpFailure extends SignUpState{
  final String errMessage;
 

  SignUpFailure({required this.errMessage});
}
final class SignUpSuccessfully extends SignUpState{
  final SignUpResponseModel signUpResponse;

  SignUpSuccessfully({required this.signUpResponse});
}

