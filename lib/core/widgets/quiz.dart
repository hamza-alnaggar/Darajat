import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button_2.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(Icons.close,size: 20.r,color: CustomColors.dark,)
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Text('Quiz Name',style: theme.bodyLarge,),
          SizedBox(height: 10.h,),
          Text("Quiz 1 | 3 Questions",style: theme.bodyMedium,),
          SizedBox(height: 10.h,),
          Text("quiz description",style: theme.bodyMedium,),
          SizedBox(height: 20.h,),
          AppTextButton2(buttonText: 'start quiz', onpressed: (){}),
          TextButton(onPressed: (){}, child: Text(
            'skip quiz',style: theme.bodySmall,
          ))
        ],
      ),
    );
  }
}

/// Immutable data model for the question.
class Question {
  final String prompt;
  final List<String> options;
  final int correctIndex;

  const Question({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });
}

/// Our single sample question.
const sampleQuestion = Question(
  prompt: 'Gogigivi',
  options: ['Kfigigig', 'If I g', 'Cufici', 'Uciciviv'],
  correctIndex: 2, // "Cufici"
);

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? _selectedIndex;
  bool? _isCorrect;

  void _selectOption(int ?idx) {
    if (_isCorrect != null) return; // lock after answered
    setState(() => _selectedIndex = idx);
  }

  void _submit() {
    if (_selectedIndex == null || _isCorrect != null) return;
    setState(() {
      _isCorrect = (_selectedIndex == sampleQuestion.correctIndex);
    });
  }

  void _skip() {
    // Reset for this demo
    setState(() {
      _selectedIndex = null;
      _isCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body:_buildResonOfQuestions(theme)
       //Column(
       // children: [
          // Progress
      //     Padding(
      //       padding: const EdgeInsets.all(12),
      //       child: Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text(
      //           '1 of 1',
      //           style: Theme.of(context).textTheme.bodyMedium,
      //         ),
      //       ),
      //     ),

      //     // Question
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16),
      //       child: Card(
      //         elevation: 2,
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(12)),
      //         child: Padding(
      //           padding: const EdgeInsets.all(16),
      //           child: Text(
      //             sampleQuestion.prompt,
      //             style: Theme.of(context).textTheme.headlineSmall,
      //           ),
      //         ),
      //       ),
      //     ),

      //     const SizedBox(height: 16),

      //     // Options
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: sampleQuestion.options.length,
      //         itemBuilder: (context, idx) {
      //           final text = sampleQuestion.options[idx];
      //           final isSelected = _selectedIndex == idx;

      //           // Decide border/text color after submit
      //           Color borderClr = Colors.grey.shade400;
      //           Color? textClr;
      //           if (_isCorrect != null) {
      //             if (idx == sampleQuestion.correctIndex) {
      //               borderClr = Colors.green;
      //               textClr = Colors.green;
      //             } else if (isSelected && _isCorrect == false) {
      //               borderClr = Colors.red;
      //               textClr = Colors.red;
      //             }
      //           }

      //           return Padding(
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //             child: GestureDetector(
      //               onTap: () => _selectOption(idx),
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                   border: Border.all(color: borderClr),
      //                   borderRadius: BorderRadius.circular(8),
      //                 ),
      //                 child: Row(
      //                   children: [
      //                     Radio<int>(
      //                       value: idx,
      //                       groupValue: _selectedIndex,
      //                       onChanged:
      //                           _isCorrect == null ? _selectOption : null,
      //                     ),
      //                     Expanded(
      //                       child: Text(
      //                         text,
      //                         style: TextStyle(color: textClr),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ),

      //     // Feedback banner
      //     if (_isCorrect == true)
      //       _FeedbackBanner(
      //         text: 'Great job! You got it right.',
      //         icon: Icons.check_circle_outline,
      //         background: Colors.green.shade50,
      //       ),
      //     if (_isCorrect == false)
      //       _FeedbackBanner(
      //         text: 'Incorrect answer. Please try again.',
      //         icon: Icons.error_outline,
      //         background: Colors.red.shade50,
      //       ),

      //     // Controls
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //       child: Row(
      //         children: [
      //           TextButton(
      //             onPressed: _skip,
      //             child: const Text('Skip'),
      //           ),
      //           const Spacer(),
      //           ElevatedButton(
      //             onPressed: (_selectedIndex != null && _isCorrect == null)
      //                 ? _submit
      //                 : null,
      //             child: const Text('Check answer'),
      //           ),
      //         ],
      //       ),
      //     ),
        // ],
       //),
    );
  }
}
Widget _buildResonOfQuestions(TextTheme theme){

  return Column(
    children: [
      Container(
        color: Colors.green,
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  whiteLine(),
                  SizedBox(
                    width: 5.w,
                  ),
                  Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Icon(Icons.star_outline,color: Colors.green,),
                  ),
                  SizedBox(width: 5.w,),
                  whiteLine(),
                ],
                
              ),
              SizedBox(height: 10.h,),
              Text("Great job!You are ready to move on to the next lecture",style: theme.headlineSmall,),
              SizedBox(height: 10.h,),
              Text("you got 1 out of 1 correct",style: theme.bodySmall,),
            ],
          ),
        ) ,
      ),
      SizedBox(height: 20.h,),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
        child: Row(
          children: [
            Icon(Icons.check,color: Colors.green,),
           // Text()
          ],
        ),
      )
    ],
  );
}

Container whiteLine() {
  return Container(
              width: 150.w,
              height: 2.h,
              color: Colors.white,
            );
}

/// Simple banner widget for feedback.
class _FeedbackBanner extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color background;

  const _FeedbackBanner({
    required this.text,
    required this.icon,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
