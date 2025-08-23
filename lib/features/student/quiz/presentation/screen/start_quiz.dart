import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button_2.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

class StartQuizScreen extends StatelessWidget {
  const StartQuizScreen({super.key,required this.quizModel});

 final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? CustomColors.backgroundColor : Colors.grey.shade50,
      body: SafeArea(
        child: startQuizWidget(quizModel: quizModel),
      ),
    );
  }
}

class startQuizWidget extends StatelessWidget {
  const startQuizWidget({
    super.key,
    required this.quizModel,
  });

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    final textColor = isDark ? Colors.white : Colors.black;
    
    return Padding(
      padding: EdgeInsets.only(left: 15.w, top: 80.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(quizModel.quizName, 
          //     style: theme.headlineMedium?.copyWith(color: textColor)),
          SizedBox(height: 10.h),
          Text("Quiz ${quizModel.quizId} | ${quizModel.numOfQuestions} Questions", 
              style: theme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white70 : Colors.grey.shade700)),
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
                  textStyle: theme.headlineSmall?.copyWith(color: Colors.white),
                  onpressed: () {
                    context.pushReplacementNamed(Routes.questionScreen,arguments: quizModel);
                  },
                ),
              ),
              SizedBox(width: 10.w),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('skip quiz', 
                    style: theme.headlineSmall?.copyWith(
                        color: isDark ? Colors.white70 : CustomColors.primary2)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
