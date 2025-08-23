import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';

import 'package:learning_management_system/features/sign_up/data/models/sign_up_body_model.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/sign_up_repository_impl.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.signUpRepository}) : super(SignUpInitial());

  SignUpRepository signUpRepository ;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();

final _nameRegExp = RegExp(r'^[\p{L}\s]+$', unicode: true);
final _upperCaseRegExp = RegExp(r'[A-Z]');
final _lowerCaseRegExp = RegExp(r'[a-z]');
final _digitRegExp     = RegExp(r'\d');
final _symbolRegExp    = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  
  
  final formKey = GlobalKey<FormState>();


  // Sign Up Method
  Future<void> eitherFailureOrSignUp({required int ?countryId,required int ?languageId}) async {
    if (!formKey.currentState!.validate()) return;
    emit(SignUpLoading());
    final failureOrSignUp = await signUpRepository.signup(
      signUpBodyModel: SignUpBodyModel(
        languageId: languageId,
        lastName: lastNameController.text, fistName: firstNameController.text, email: emailController.text, password: passwordController.text, passwordConfirm: passwordConfirmationController.text, countryId: countryId)
      );
    failureOrSignUp.fold(
      (failure) => emit(SignUpFailure(errMessage: failure.errMessage)),
      (user) async{
        await saveUserEmail(user.user.email);
        emit(SignUpSuccessfully(message:user.message));
      } 
    );
  }
  Future<void> saveUserEmail(String email ) async {
    await SharedPrefHelper.setData("email", email);

  }

    String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required.';
    if (value.length > 50)             return 'Must be at most 50 characters.';
    if (!_nameRegExp.hasMatch(value))  return 'Only letters and spaces allowed.';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty)      return 'Email is required.';
    if (value.length > 255)                  return 'Must be at most 255 characters.';
    if (!EmailValidator.validate(value))     return 'Invalid email address.';
    // NOTE: “unique:people” can only be enforced server‐side; you could optionally do an async call here.
    return null;
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
