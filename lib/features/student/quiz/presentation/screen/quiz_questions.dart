import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
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

class _QuizPageState extends State<QuizQuestions> with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  bool? _isCorrect;
  int _currentQuestionIndex = 0;
  String? _correctAnswer;
  String? _explanation;
    bool _isChecking = false;

  final List<AnswerModel> _answers = [];

  late final AnimationController _animController;

  QuestionSubModels get currentQuestion => widget.quizModel.questions[_currentQuestionIndex];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectOption(int? idx) {
    if (_isCorrect != null) return; // lock after answer processed
    setState(() => _selectedIndex = idx);
  }

    void _submit() async {
    if (_selectedIndex == null || _isCorrect != null || _isChecking) return;

    setState(() => _isChecking = true);

    final answer = String.fromCharCode(97 + _selectedIndex!);

    _answers.removeWhere((a) => a.questionId == currentQuestion.questionId);
    _answers.add(AnswerModel(
      questionId: currentQuestion.questionId!,
      answer: answer,
    ));

    try {
      final success = await context.read<QuizCubit>().processAnswer(
        quizId: widget.quizModel.quizId,
        questionNumber: currentQuestion.questionNumber,
        answer: answer,
      );

      if (!success) {
        _answers.removeWhere((a) => a.questionId == currentQuestion.questionId);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }


  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quizModel.questions.length - 1) {
      _animController.forward(from: 0).whenComplete(() {
        setState(() {
          _currentQuestionIndex++;
          _selectedIndex = null;
          _isCorrect = null;
          _correctAnswer = null;
          _explanation = null;
        });
      });
    } else {
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
            arguments: {'result': state.quizResultModel},
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
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? CustomColors.backgroundColor
            : const Color(0xFFF6F8FB),
        appBar: CustomAppBar(
          title: 
            'Question ${_currentQuestionIndex + 1}/${widget.quizModel.numOfQuestions}',
          
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopProgress(context),
                SizedBox(height: 18.h),
                Expanded(child: _buildQuestionCard(context)),
                SizedBox(height: 12.h),
                _buildActionRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopProgress(BuildContext context) {
    final total = widget.quizModel.numOfQuestions;
    final current = _currentQuestionIndex + 1;
    final percent = (current / total).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(percent * 100).toInt()}% complete',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              'Question $current of $total',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(height: 8.h),
      ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: SizedBox(
    height: 8.h, 
    child: Stack(
      children: [
        // Background
        Container(
          color: Colors.white,
        ),
        // Progress
        FractionallySizedBox(
          widthFactor: percent,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF2196F3),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
)
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? CustomColors.secondary : Colors.white;

    final options = [
      currentQuestion.answerA,
      currentQuestion.answerB,
      currentQuestion.answerC,
      currentQuestion.answerD,
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentQuestion.content,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 14.h),
                ...List.generate(options.length, (idx) {
                  final text = options[idx];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: _OptionTile(
                      index: idx,
                      text: text,
                      isSelected: _selectedIndex == idx,
                      locked: _isCorrect != null,
                      correctAnswer: _correctAnswer,
                      isCorrectFlag: _isCorrect,
                      onTap: () => _selectOption(idx),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Feedback
          if (_isCorrect != null) ...[
            SizedBox(height: 12.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: _isCorrect == true
                    ? (Theme.of(context).brightness == Brightness.dark ? Colors.green[900] : Colors.green.shade50)
                    : (Theme.of(context).brightness == Brightness.dark ? Colors.red[900] : Colors.red.shade50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _isCorrect == true ? Icons.check_circle : Icons.error_outline,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isCorrect == true ? 'Correct!' : 'Incorrect',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (_explanation != null) ...[
                          SizedBox(height: 8.h),
                          Text(
                            _explanation!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],
                        if (_correctAnswer != null && _isCorrect == false) ...[
                          SizedBox(height: 8.h),
                          Text(
                            'Correct answer: ${_correctAnswer!.toUpperCase()}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    final lastQuestion = _currentQuestionIndex == widget.quizModel.questions.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back or Cancel
        TextButton(
          onPressed: () async {
            // Confirm before leaving mid-quiz
            final leave = await showDialog<bool?>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Leave quiz?'),
                content: const Text('Are you sure you want to exit? Your progress will be lost.'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
                  TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
                ],
              ),
            );
            if (leave == true) Navigator.of(context).pop();
          },
          child: Text('Exit', style: TextStyle(color: Colors.grey.shade700,fontSize: 17)),
        ),

        Row(
          children: [
          ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: CustomColors.primary2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
  ),
  onPressed: (_selectedIndex != null && _isCorrect == null && !_isChecking)
      ? _submit
      : null,
  child: _isChecking
      ? SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
      : Text(
          lastQuestion ? 'Submit quiz' : 'Check answer',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
),

            SizedBox(width: 10.w),
            if (_isCorrect != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primary2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                onPressed: _nextQuestion,
                child: Text(
                  lastQuestion ? 'Finish' : 'Next',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 16),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool locked; // whether answer has been processed
  final String? correctAnswer;
  final bool? isCorrectFlag; // whether the last processed answer was correct
  final VoidCallback onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.locked,
    required this.correctAnswer,
    required this.isCorrectFlag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode(65 + index); // A B C D
    final optionKey = String.fromCharCode(97 + index); // a b c d
    final theme = Theme.of(context);

    Color base = theme.brightness == Brightness.dark ? CustomColors.secondary : Colors.white;
    Color border = Colors.grey.shade300;

    // Colors for states
    bool thisIsCorrect = correctAnswer != null && optionKey == correctAnswer;
    bool thisIsSelectedWrong = isSelected && locked && isCorrectFlag == false;

    if (thisIsCorrect) {
      border = Colors.green;
    } else if (thisIsSelectedWrong) {
      border = Colors.red;
    } else if (isSelected) {
      border = CustomColors.primary2;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: locked ? null : onTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: isSelected ? CustomColors.primary2 : Colors.transparent,
              child: Text(
                letter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
              ),
            ),
            // Status icons when locked
            if (locked) ...[
              if (thisIsCorrect)
                const Icon(Icons.check_circle, color: Colors.green)
              else if (thisIsSelectedWrong)
                const Icon(Icons.cancel, color: Colors.red)
              else
                const SizedBox.shrink(),
            ],
          ],
        ),
      ),
    );
  }
}
