import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/student/quiz/data/models/answer_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/sub_models/question_sub_models.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_state.dart';

class QuizQuestions extends StatefulWidget {
  final QuizModel quizModel;

  const QuizQuestions({
    super.key,
    required this.quizModel,
  });

  @override
  State<QuizQuestions> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizQuestions> {
  int? _selectedIndex;
  bool? _isCorrect;
  int _currentQuestionIndex = 0;
  String? _correctAnswer;
  String? _explanation;
  final List<AnswerModel> _answers = [];

  QuestionSubModels get currentQuestion {
    return widget.quizModel.questions[_currentQuestionIndex];
  }

  void _selectOption(int? idx) {
    if (_isCorrect != null) return; // lock after answered
    setState(() => _selectedIndex = idx);
  }

  void _submit() {
    if (_selectedIndex == null || _isCorrect != null) return;
    
    // Get the selected answer letter (a, b, c, d)
    final answer = String.fromCharCode(97 + _selectedIndex!); // 97 = 'a' in ASCII
    
    _answers.add(AnswerModel(
      questionId: currentQuestion.questionId!,
      answer: answer,
    ));
    
    context.read<QuizCubit>().processAnswer(
      quizId: widget.quizModel.quizId,
      questionNumber: currentQuestion.questionId!,
      answer: answer,
    );
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quizModel.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedIndex = null;
        _isCorrect = null;
        _correctAnswer = null;
        _explanation = null;
      });
    } else {
      // Quiz finished - calculate results
      _calculateResults();
    }
  }
  
  void _calculateResults() {
    context.read<QuizCubit>().calculateQuizResult(
      quizId: widget.quizModel.quizId,
      answers: _answers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is ProcessAnswerSuccessfully) {
          setState(() {
            _isCorrect = state.answerModel.isCorrect;
            _correctAnswer = state.answerModel.rightAnswer;
            _explanation = state.answerModel.explanation;
          });
        } else if (state is CalculateQuizResultSuccessfully) {
          context.pushReplacementNamed(
            Routes.resultScreen,
            arguments: {'result': state.quizResultModel}
          );
        } else if (state is ProcessAnswerFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
        } else if (state is CalculateQuizResultFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Question ${_currentQuestionIndex + 1}/${widget.quizModel.questions.length}'),
        ),
        body: _buildQuestionContent(context),
      ),
    );
  }

  Widget _buildQuestionContent(BuildContext context) {
    final options = [
      currentQuestion.answerA,
      currentQuestion.answerB,
      currentQuestion.answerC,
      currentQuestion.answerD,
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    final backgroundColor = isDark ? CustomColors.backgroundColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final surfaceColor = isDark ? CustomColors.darkContainer : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final iconColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return Container(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(left: 15.w, top: 30.h, right: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}:',
              style: theme.headlineSmall?.copyWith(color: textColor),
            ),
            SizedBox(height: 20.h),
            Text(
              currentQuestion.content,
              style: theme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
            SizedBox(height: 20.h),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, idx) {
                  final text = options[idx];
                  final isSelected = _selectedIndex == idx;
                  final optionLetter = String.fromCharCode(97 + idx); // a, b, c, d

                  // Decide border/text color after submit
                  Color borderClr = isDark ? Colors.grey.shade700 : Colors.grey.shade400;
                  Color? textClr;
                  if (_isCorrect != null) {
                    if (optionLetter == _correctAnswer) {
                      borderClr = Colors.green;
                      textClr = Colors.green;
                    } else if (isSelected && _isCorrect == false) {
                      borderClr = Colors.red;
                      textClr = Colors.red;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () => _selectOption(idx),
                      child: Container(
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          border: Border.all(color: borderClr),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: idx,
                              activeColor: CustomColors.primary2,
                              groupValue: _selectedIndex,
                              onChanged: _isCorrect == null ? _selectOption : null,
                            ),
                            Expanded(
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: textClr ?? textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Feedback banner
            if (_isCorrect == true)
              _FeedbackBanner(
                text: 'Great job! You got it right.',
                icon: Icons.check_circle_outline,
                background: isDark ? Colors.green[900]! : Colors.green.shade50,
                explanation: _explanation,
                textColor: textColor,
              ),
            if (_isCorrect == false)
              _FeedbackBanner(
                text: 'Incorrect answer. Please try again.',
                icon: Icons.error_outline,
                background: isDark ? Colors.red[900]! : Colors.red.shade50,
                explanation: _explanation,
                textColor: textColor,
              ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isCorrect == null || 
                      _currentQuestionIndex == widget.quizModel.questions.length - 1)
                    TextButton(
                      onPressed: () {
                        if (_currentQuestionIndex < widget.quizModel.questions.length - 1) {
                          _nextQuestion();
                        } else {
                          _calculateResults();
                        }
                      },
                      child: Text(
                        _currentQuestionIndex < widget.quizModel.questions.length - 1 
                          ? 'Skip' 
                          : 'Finish',
                        style: theme.headlineSmall?.copyWith(
                          color: isDark ? Colors.white70 : CustomColors.primary2,
                        ),
                      ),
                    ),
                  if (_isCorrect == null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primary2,
                        ),
                        onPressed: (_selectedIndex != null && _isCorrect == null)
                            ? _submit
                            : null,
                        child: Text(
                          _currentQuestionIndex < widget.quizModel.questions.length - 1 
                            ? 'Check answer' 
                            : 'Submit quiz',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  if (_isCorrect != null && 
                      _currentQuestionIndex < widget.quizModel.questions.length - 1)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primary2,
                        ),
                        onPressed: _nextQuestion,
                        child: Text(
                          'Next Question',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color background;
  final String? explanation;
  final Color textColor;

  const _FeedbackBanner({
    required this.text,
    required this.icon,
    required this.background,
    this.explanation,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
              Text(text, style: TextStyle(color: textColor)),
            ],
          ),
          if (explanation != null) ...[
            const SizedBox(height: 8),
            Text(
              explanation!,
              style: TextStyle(
                color: textColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}