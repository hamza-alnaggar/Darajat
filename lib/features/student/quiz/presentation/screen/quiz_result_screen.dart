import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_result_model.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResultModel result;

  const QuizResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    final backgroundColor = isDark ? CustomColors.backgroundColor : Colors.white;
    final headerColor = isDark ? Colors.green[800]! : const Color.fromARGB(255, 73, 123, 75);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Quiz Result'),
        backgroundColor: headerColor,
      ),
      body: Column(
        children: [
          Container(
            color: headerColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      whiteLine(isDark: isDark),
                      SizedBox(width: 10.w),
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Icon(Icons.star_outline, color: headerColor),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      whiteLine(isDark: isDark),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    result.success == 1 
                      ? "Great job! You passed the quiz!" 
                      : "You did not pass this time. Keep practicing!",
                    style: theme.headlineSmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Your score: ${result.mark} (${result.percentageMark})",
                    style: theme.bodyLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "Quiz completed!",
                    style: theme.headlineMedium?.copyWith(
                        color: isDark ? Colors.white : Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark 
                            ? CustomColors.primary2 
                            : CustomColors.primary2,
                      ),
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: Text('Back to Course',
                          style: TextStyle(
                              color: isDark ? Colors.black : Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Container whiteLine({required bool isDark}) {
  return Container(
    width: 140.w,
    height: 2.h,
    color: isDark ? Colors.grey[300] : Colors.white,
  );
}