import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button_2.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_state.dart';
import 'package:lottie/lottie.dart';

class StartQuizScreen extends StatelessWidget {
  const StartQuizScreen({super.key, required this.quizModel});

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? CustomColors.backgroundColor
          : Colors.grey.shade50,
      body: SafeArea(child: startQuizWidget(quizModel: quizModel)),
    );
  }
}

class startQuizWidget extends StatelessWidget {
  const startQuizWidget({super.key, required this.quizModel});

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    final textColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: EdgeInsets.only(left: 15.w, top: 80.h),
      child: BlocListener<QuizCubit, QuizState>(
        listener: (context, state) {
          if(state is QuizSuccessfully){
            context.pushReplacementNamed(
                        Routes.questionScreen,
                        arguments: quizModel,
                      );
          }
          if(state is QuizFailure){
            final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    color: Colors.red,
                    title: 'On Snap!',
                    message:
                        state.errMessage,
                    contentType: ContentType.failure,
                  ),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
          }
          if(state is QuizLoading){
            showDialog(
              context: context,
              builder:(context) => Lottie.asset('assets/images/loading.json'),
              );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Quiz ${quizModel.quizId} | ${quizModel.numOfQuestions} Questions",
              style: theme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 10.h),
            // Text(quizModel.quizDescription,
            //     style: theme.headlineSmall?.copyWith(
            //         fontWeight: FontWeight.w400,
            //         color: isDark ? Colors.white70 : Colors.grey.shade700)),
            SizedBox(height: 50.h),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: AppTextButton2(
                    buttonText: 'Start quiz',
                    textStyle: theme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                    onpressed: () {
                       context.pushReplacementNamed(
                        Routes.questionScreen,
                        arguments: quizModel,
                      );
                    //  context.read<QuizCubit>().eitherFailureOrStartQuiz(quizId: quizModel.quizId);
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'skip quiz',
                    style: theme.headlineSmall?.copyWith(
                      color: isDark ? Colors.white70 : CustomColors.primary2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
