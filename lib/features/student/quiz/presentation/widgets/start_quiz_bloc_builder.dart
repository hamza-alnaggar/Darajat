import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_state.dart';
import 'package:learning_management_system/features/student/quiz/presentation/screen/start_quiz.dart';

class StartQuizBlocBuilder extends StatelessWidget {
  const StartQuizBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (context, state) {
        print(state);
        if (state is QuizSuccessfully) {
        return  startQuizWidget(quizModel: state.quizModel);
        } else if (state is QuizFailure) {
        return Center(
          child: Text(
            state.errMessage
          ),
        );
        } else if (state is QuizLoading) {
        Center(
              child: CircularProgressIndicator(color: CustomColors.primary2),
          );
        }
        return SizedBox.shrink();
      }
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
          Text(message),
        
      
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 3),
    ),
  );
}

  dynamic setupErrorState(BuildContext context, String error) {
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
