import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_cubit.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_state.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
  listenWhen: (previous, current) {
    return current is LoginLoading ||
        current is LoginSuccessfully ||
        current is LoginFailure;
  },
  
      listener: (context, state) {
        if (state is LoginFailure) {
          context.pop();
        _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
        } else if (state is LoginSuccessfully) {
          context.pop();
          signUpSuccessfully(context);
        } else if (state is LoginLoading) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: CustomColors.primary2),
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  void signUpSuccessfully(BuildContext context) {
    showSuccessDialog(context);
  }

  void _showSnackBar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
}) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: 
          Text(message),
        
      
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 3),
    ),
  );
}

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Successful'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Congratulations, you have signed up successfully!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: CustomColors.primary2,
              ),
              onPressed: () {
                //context.pushNamed(Routes.loginScreen);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void setupErrorState(BuildContext context, String error) {
    context.pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error,
          color: Colors.red,
          size: 32,
        ),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
