import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/student/quiz/data/models/sub_models/question_sub_models.dart';

class QuestionItem extends StatelessWidget {
  final QuestionSubModels question;
  final bool isDark;
  final bool isEditing;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const QuestionItem({
    required this.question,
    required this.isDark,
    required this.isEditing,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  question.content,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (isEditing)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 18.r),
                      onPressed: onEdit,
                      color: isDark ? Colors.blueAccent : Colors.blue,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 18.r),
                      onPressed: onDelete,
                      color: Colors.red,
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildAnswer('A', question.answerA),
          _buildAnswer('B', question.answerB),
          _buildAnswer('C', question.answerC),
          _buildAnswer('D', question.answerD),
          SizedBox(height: 8.h),
          if (question.rightAnswer != null)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Correct Answer: ${question.rightAnswer}',
                style: TextStyle(
                  color: isDark ? Colors.lightGreen : Colors.green.shade800,
                ),
              ),
            ),
          SizedBox(height: 8.h),
          if(question.explanation != null)
          if (question.explanation!.isNotEmpty)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                question.explanation!,
                style: TextStyle(
                  color: isDark ? Colors.lightBlueAccent : Colors.blue.shade800,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnswer(String letter, String answer) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text('$letter: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(answer)),
        ],
      ),
    );
  }
}
