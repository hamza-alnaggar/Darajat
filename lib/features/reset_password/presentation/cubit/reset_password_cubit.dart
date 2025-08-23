import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/features/reset_password/data/models/reset_password_body.dart';
import 'package:learning_management_system/features/reset_password/data/repositories/reset_password_repository.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/reset_password_state.dart';


class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required this.resetPasswordRepository,required this.code}) : super(ResetPasswordInitial());

  final ResetPasswordRepository resetPasswordRepository;
  final String ?code;


  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();

final _upperCaseRegExp = RegExp(r'[A-Z]');
final _lowerCaseRegExp = RegExp(r'[a-z]');
final _digitRegExp     = RegExp(r'\d');
final _symbolRegExp    = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  

  
  final formKey = GlobalKey<FormState>();


  // Sign Up Method
  Future<void> eitherFailureOrResetPassword() async {
    emit(ResetPasswordLoading());
    
    final failureOrResetPassword = await resetPasswordRepository.resetPassword(
      resetPasswordBody: ResetPasswordBody(
        code:code!, password: passwordController.text,passwordConfirm: passwordConfirmationController.text
        )
    );
    failureOrResetPassword.fold(
      (failure) => emit(ResetPasswordFailure(errMessage: failure.errMessage)),
      (resetPassword) async{
        emit(ResetPasswordSuccessfully(resetPassword: resetPassword));
      } 
    );
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8)              return 'Must be at least 8 characters.';
    if (!_upperCaseRegExp.hasMatch(value)) return 'Include at least one uppercase letter.';
    if (!_lowerCaseRegExp.hasMatch(value)) return 'Include at least one lowercase letter.';
    if (!_digitRegExp.hasMatch(value))     return 'Include at least one digit.';
    if (!_symbolRegExp.hasMatch(value))    return 'Include at least one symbol.';
    return null;
  }

  String? validatePasswordConfirmation(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != passwordController.text)  return 'Passwords do not match.';
    return null;
  }


}
