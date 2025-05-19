import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/login/data/models/login_body_model.dart';
import 'package:learning_management_system/features/login/data/repositories/login_repository.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginRepository}) : super(LoginInitial());

  LoginRepository loginRepository ;

  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  
  final formKey = GlobalKey<FormState>();


  // Sign Up Method
  Future<void> eitherFailureOrLogin() async {
    //if (!formKey.currentState!.validate()) return;
    emit(LoginLoading());
    final failureOrSignUp = await loginRepository.login(
      loginBodyModel: LoginBodyModel(
        email: emailController.text, password: passwordController.text,)
      );
    failureOrSignUp.fold(
      (failure) => emit(LoginFailure(errMessage: failure.errMessage)),
      (user) async{
           await saveUserToken(user.accessToken);
          emit(LoginSuccessfully(loginResponseModel: user));
      } 
    );
  }


  Future<void> saveUserToken(String accessToken ) async {
    await SharedPrefHelper.setData("accessToken", accessToken);
    
    
  }



}
