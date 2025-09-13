import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_cubit.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_state.dart';
import 'package:lottie/lottie.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
  listenWhen: (previous, current) {
    return current is LoginLoading ||
        current is LoginSuccessfully ||
        current is LoginGoogleSuccessfully||
        current is LoginFailure;
  },
  
      listener: (context, state) {
        if (state is LoginFailure) {
          context.pop();
        _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
        } else if (state is LoginSuccessfully) {
          context.pop();
          context.pushReplacementNamed(Routes.entryPoint);
        } else if (state is LoginLoading) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>  Center(
              child: Lottie.asset('assets/images/loading.json')
            ),
          );
        }
        else if(state is LoginGoogleSuccessfully){
                    context.pop();
context.pushReplacementNamed(Routes.entryPoint);

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
