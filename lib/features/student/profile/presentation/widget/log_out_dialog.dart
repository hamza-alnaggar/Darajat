import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/features/logout/presentation/cubit/log_out_cubit.dart';
import 'package:learning_management_system/features/logout/presentation/cubit/log_out_state.dart';
import 'package:learning_management_system/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  Future<void> _clearPreferencesAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('otpSuccessfully');
    await prefs.remove('isSignedUp');
    await prefs.remove('isTeacherView');
    await prefs.remove('accessToken');
    await prefs.remove('email');
    
    
    
    context.pushNamedAndRemoveUntil(
      Routes.loginScreen,
      predicate: (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state is LogOutSuccessfully) {
          Navigator.of(context).pop(); 
          _clearPreferencesAndNavigate(context);
          context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate:(route) => false,);
        }
        if (state is LogOutFailure) {
          Navigator.of(context).pop(); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: Text(S.of(context).Sign_Out, style: TextStyle(fontSize: 22.sp)),
        content: Text(
          S.of(context).Are_you_sure_you_want_to_sign_out,
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              S.of(context).Cancel,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          BlocBuilder<LogOutCubit, LogOutState>(
            builder: (context, state) {
              return TextButton(
                onPressed: state is LogOutLoading
                    ? null
                    : () => context.read<LogOutCubit>().eitherFailureOrLogOut(),
                child: state is LogOutLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                    : Text(
                        S.of(context).Sign_Out,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }}