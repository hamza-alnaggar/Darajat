import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/student/quiz/data/models/sub_models/question_sub_models.dart';

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
    
    // Initialize with initial question if exists
    _questionController = TextEditingController(
      text: widget.initialQuestion?.content ?? ''
    );
    
    // Set correct answer index
    final initialRightAnswer = widget.initialQuestion?.rightAnswer;
    _correctIndex = initialRightAnswer == 'a' ? 0 : 
                    initialRightAnswer == 'b' ? 1 : 
                    initialRightAnswer == 'c' ? 2 : 3;
    
    // Initialize controllers for answers
    _answerControllers = [
      TextEditingController(text: widget.initialQuestion?.answerA ?? ''),
      TextEditingController(text: widget.initialQuestion?.answerB ?? ''),
      TextEditingController(text: widget.initialQuestion?.answerC ?? ''),
      TextEditingController(text: widget.initialQuestion?.answerD ?? ''),
    ];
    
    // Initialize controllers for explanations
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Field
          Text('Question', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: _questionController,
            minLines: 3,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the question',
            ),
          ),
          const SizedBox(height: 24),
          Text('Answers', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          // Answer Fields
          for (int i = 0; i < 4; i++) _buildAnswerTile(i),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitQuestion,
                  child: Text("Save Question"),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: Text("Cancel"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Radio<int>(
                value: index,
                groupValue: _correctIndex,
                onChanged: (val) => setState(() => _correctIndex = val!),
              ),
              Text('Correct Answer', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Option ${String.fromCharCode(65 + index)}', // A, B, C, D
            style: TextStyle(fontSize: 14.sp),
          ),
          TextFormField(
            controller: _answerControllers[index],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Answer text...',
            ),
          ),
          const SizedBox(height: 8),
          Text('Explanation (optional)', style: TextStyle(fontSize: 14.sp)),
          TextFormField(
            controller: _explanationControllers[index],
            minLines: 2,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Why this answer is correct...',
            ),
          ),
          const SizedBox(height: 16),
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