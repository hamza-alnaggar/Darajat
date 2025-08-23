import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/reset_password/data/models/check_code_reset_password_response.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/check_code_reset_password_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/check_code_reset_password_state.dart';
import 'package:lottie/lottie.dart';

class CheckCodeResetPasswordBlocListener extends StatelessWidget {
  const CheckCodeResetPasswordBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckCodeResetPasswordCubit, CheckCodeResetPasswordState>(
      listener: (context, state) {
        if (state is CheckCodeFailure) {
          context.pop();
        _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
        } else if (state is CheckCodeSuccessfully) {
          context.pop();
          context.pushNamedAndRemoveUntil(Routes.resetPasswordScreen,arguments: state.checkCode.code,predicate: (route) => route.settings.name == Routes.loginScreen,);
        } else if (state is CheckCodeLoading) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>  Center(
              child: Lottie.asset('assets/images/loading.json')
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }

 
  
  void _showSnackBar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
}) {
  final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    color: backgroundColor,
                    title: 'On Snap!',
                    message:
                        message,

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }


  void showSuccessDialog(BuildContext context,CheckCodeResetPasswordResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('check Code Successfully'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ok, now you can set a new password!'),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: 150.w,
              child: AppTextButton(
                onpressed: () {
                  context.pushNamed(Routes.resetPasswordScreen,arguments:response.code );
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