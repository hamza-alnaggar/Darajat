import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';

import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/sign_up_state.dart';
import 'package:lottie/lottie.dart';
class SignupBlocListener extends StatelessWidget {
  const SignupBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
  listenWhen: (previous, current) {
    return current is SignUpLoading ||
        current is SignUpSuccessfully ||
        current is SignUpFailure;
  },
  
      listener: (context, state) {
        if (state is SignUpFailure) {
          context.pop();
        _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
        } else if (state is SignUpSuccessfully) {
          context.pop();
          SharedPrefHelper.setData('isSignedUp',true);
          context.pushReplacementNamed(Routes.otpScreen);
        } else if (state is SignUpLoading) {
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
