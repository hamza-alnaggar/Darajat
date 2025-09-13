import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/core/widgets/firebase_auth_service.dart';
import 'package:learning_management_system/features/login/data/models/login_body_model.dart';
import 'package:learning_management_system/features/login/data/repositories/login_repository.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginRepository,required this.googleAuthService}) : super(LoginInitial());

  LoginRepository loginRepository ;
  final GoogleAuthService googleAuthService; // أضف هذا


  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  
  final formKey = GlobalKey<FormState>();


  // Sign Up Method
  Future<void> eitherFailureOrLogin() async {
    emit(LoginLoading());
    final failureOrSignUp = await loginRepository.login(
      loginBodyModel: LoginBodyModel(
        email: emailController.text, password: passwordController.text,)
      );
    failureOrSignUp.fold(
      (failure) => emit(LoginFailure(errMessage: failure.errMessage)),
      (user) async{
          await saveUserToken(user.user.token!);
          emit(LoginSuccessfully(loginResponseModel: user));
      } 
    );
  }
  Future<void> signInWithGoogle() async {
  emit(LoginLoading());
  
  try {

    final userCredential = await GoogleAuthService().signInWithGoogle();
    final idToken = await userCredential.user!.getIdToken();
    final failureOrSignUp = await loginRepository.loginWithGoogle(token: idToken!);
    
    failureOrSignUp.fold(
      (failure) => emit(LoginFailure(errMessage: failure.errMessage)),
      (user) async {
        await saveUserToken(user.token);
        await SharedPrefHelper.setData('userId',user.id);
        emit(LoginGoogleSuccessfully());
      },
    );
  } catch (e) {
    print('Sign-In Error: $e');
    emit(LoginFailure(errMessage: 'Failed to sign in with Google: $e'));
  }
}
}


  Future<void> saveUserToken(String accessToken ) async {
    await SharedPrefHelper.setData("accessToken", accessToken);

  }


