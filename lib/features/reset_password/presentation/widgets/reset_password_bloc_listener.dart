import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/reset_password_state.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordBlocListener extends StatelessWidget {
  const ResetPasswordBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      

  
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          context.pop();
        _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
        } else if (state is ResetPasswordSuccessfully) {
          context.pop();
          checkSuccessfully(context);
        } else if (state is ResetPasswordLoading) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder:(context)=> Center(
            child: Lottie.asset('assets/images/loading.json')

            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  void checkSuccessfully(BuildContext context) {
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('resetPassword Successfully'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Congradulation, You are change your Password!'),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: 150.w,
              child: AppTextButton(
                onpressed: () {
                  context.pushReplacementNamed(Routes.loginScreen);
                },
                buttonText: 'Continue',
              ),
            ),
          ],
        );
      },
    );
  }
}