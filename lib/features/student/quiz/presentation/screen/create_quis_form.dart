import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/student/quiz/data/models/sub_models/question_sub_models.dart';
import 'package:learning_management_system/generated/l10n.dart';

class CreateQuisForm extends StatefulWidget {
  final int episodeId;
  final int questionNumber;
  final QuestionSubModels? initialQuestion;
  final Function(QuestionSubModels) onSave;
  final VoidCallback onCancel;

  const CreateQuisForm({
    super.key,
    required this.episodeId,
    required this.questionNumber,
    this.initialQuestion,
    required this.onSave,
    required this.onCancel,
  });

  @override
  _QuizFormState createState() => _QuizFormState();
}

class _QuizFormState extends State<CreateQuisForm> {
  late TextEditingController _questionController;
  late int _correctIndex;
  late List<TextEditingController> _answerControllers;
  late List<TextEditingController> _explanationControllers;

  @override
  void initState() {
    super.initState();
    
    _questionController = TextEditingController(
      text: widget.initialQuestion?.content ?? ''
    );
    
    final initialRightAnswer = widget.initialQuestion?.rightAnswer;
    _correctIndex = initialRightAnswer == 'a' ? 0 : 
                    initialRightAnswer == 'b' ? 1 : 
                    initialRightAnswer == 'c' ? 2 : 3;
    
    _answerControllers = [
      TextEditingController(text: widget.initialQuestion?.answerA ?? ''),
      TextEditingController(text: widget.initialQuestion?.answerB ?? ''),
      TextEditingController(text: widget.initialQuestion?.answerC ?? ''),
      TextEditingController(text: widget.initialQuestion?.answerD ?? ''),
    ];
    
    _explanationControllers = [
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: widget.initialQuestion?.explanation ?? ''),
    ];
  }

  void _submitQuestion() {
    final question = QuestionSubModels(
      questionNumber: widget.questionNumber,
      content: _questionController.text,
      answerA: _answerControllers[0].text,
      answerB: _answerControllers[1].text,
      answerC: _answerControllers[2].text,
      answerD: _answerControllers[3].text,
      rightAnswer: ['a', 'b', 'c', 'd'][_correctIndex],
      explanation: _explanationControllers[_correctIndex].text,
    );

    widget.onSave(question);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = isDarkTheme ? CustomColors.primary : Color(0xFF6C63FF);
    final Color scaffoldBg = isDarkTheme ? Color(0xFF121212) : Color(0xFF1E1E2A);
    final Color cardBg = isDarkTheme ? Color(0xFF1E1E1E) : Color(0xFF2A2A3A);
    final Color textColor = isDarkTheme ? Colors.white : Colors.white70;
    final Color secondaryText = isDarkTheme ? Colors.grey[400]! : Colors.grey[300]!;
    final Color inputBg = isDarkTheme ? Color(0xFF2A2A2A) : Color(0xFF363647);
    
    return Theme(
      data: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputBg,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
      child: Container(
        color: scaffoldBg,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.quiz_outlined, color: Colors.amber, size: 24.w),
                  SizedBox(width: 8.w),
                  Text(
                    'Question ${widget.questionNumber}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color:Colors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              // Question Field
              Text(
                'Question Content',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: secondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _questionController,
                  minLines: 3,
                  maxLines: null,
                  style: TextStyle(fontSize: 16.sp, color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Enter your question here...',
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              
              // Answers Section
              Text(
                'Answer Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: secondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Select the correct answer and provide explanations',
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[500]),
              ),
              SizedBox(height: 16.h),
              
              // Answer Options
              for (int i = 0; i < 4; i++) _buildAnswerTile(i, primaryColor, cardBg, textColor, secondaryText, inputBg),
              SizedBox(height: 24.h),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: cardBg,
                        foregroundColor: textColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide(color: primaryColor.withOpacity(0.5)),
                      ),
                      child: Text(S.of(context).Cancel),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 4,
                        shadowColor: primaryColor.withOpacity(0.4),
                      ),
                      child: Text(S.of(context).save),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerTile(int index, Color primaryColor, Color cardBg, Color textColor, Color secondaryText, Color inputBg) {
    final optionLetters = ['A', 'B', 'C', 'D'];
    final optionColors = [
      Color(0xFFE57373), // Red
      Color(0xFF64B5F6), // Blue
      Color(0xFF81C784), // Green
      Color(0xFFBA68C8), // Purple
    ];
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: _correctIndex == index 
            ? Border.all(color: primaryColor.withOpacity(0.5), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Option Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: _correctIndex == index 
                  ? primaryColor.withOpacity(0.15)
                  : Color(0xFF262626),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                // Option Letter Indicator
                Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: optionColors[index],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      optionLetters[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Option ${optionLetters[index]}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: _correctIndex == index 
                        ? primaryColor 
                        : textColor,
                  ),
                ),
                Spacer(),
                // Correct Answer Radio
                Row(
                  children: [
                    Text(
                      'Correct',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: secondaryText,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Transform.scale(
                      scale: 1.2,
                      child: Radio<int>(
                        value: index,
                        groupValue: _correctIndex,
                        onChanged: (val) => setState(() => _correctIndex = val!),
                        activeColor: primaryColor,
                        fillColor: MaterialStateProperty.all(primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Answer Input
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _answerControllers[index],
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputBg,
                    hintText: 'Answer text...',
                  ),
                ),
                SizedBox(height: 12.h),
                
                // Explanation
                Text(
                  'Explanation (optional)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                TextFormField(
                  controller: _explanationControllers[index],
                  minLines: 2,
                  maxLines: null,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputBg,
                    hintText: 'Why this answer is correct...',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (final c in _answerControllers) {
      c.dispose();
    }
    for (final c in _explanationControllers) {
      c.dispose();
    }
    super.dispose();
  }
}