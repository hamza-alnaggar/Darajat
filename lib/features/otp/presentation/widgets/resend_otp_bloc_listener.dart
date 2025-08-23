import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/otp/presentation/cubit/otp_cubit.dart';
import 'package:learning_management_system/features/otp/presentation/cubit/otp_state.dart';
import 'package:lottie/lottie.dart';


class ResendOtpBlocListener extends StatelessWidget {
  const ResendOtpBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(

  
      listener: (context, state) {
        if (state is ResendFailure) {
          context.pop();
        _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
        } else if (state is ResendSuccessfully) {
          context.pop();
        _showSnackBar(context, message: state.resendOtp, backgroundColor: CustomColors.secondary);
        } else if (state is ResendLoading) {
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content:
      Text(message,style: TextStyle(color: Colors.white)),
      
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 3),
    ),
  );
}

}
