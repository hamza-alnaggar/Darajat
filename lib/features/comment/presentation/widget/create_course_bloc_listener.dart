import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_course_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_cousre_cubit.dart';
class CreateCourseBlocListener extends StatelessWidget {
  const CreateCourseBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCourseCubit, CreateCourseState>(
 
  
      listener: (context, state) {
        if (state is CourseFailure) {
          context.pop();
        _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
        } else if (state is CourseSuccess) {
          context.pop();
          signUpSuccessfully(context);
        } else if (state is CourseLoading) {
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

  void signUpSuccessfully(BuildContext context,) {
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
          Text(message,style: TextStyle(color: Colors.white),),
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
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('createCourse Successfully'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Congratulations, you have create course successfully!'),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: 150.w,
              child: AppTextButton(
                onpressed: () {
                  context.pushNamed(
                    Routes.otpScreen
                  );
                },
                buttonText: 'Continue',
              ),
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
