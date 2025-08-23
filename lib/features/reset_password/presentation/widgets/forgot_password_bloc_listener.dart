import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/forgot_password_state.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/forgot_passwrod_cubit.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordBlocListener extends StatelessWidget {
  const ForgotPasswordBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(

  
      listener: (context, state) {
        if (state is ForgotPasswordFailure) {
          context.pop();
        _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
        } else if (state is ForgotPasswordSuccessfully) {
          context.pop();
          context.pushNamed(Routes.checkCodeResetPassword);

        } else if (state is ForgotPasswordLoading) {
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

                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              
}

 
}