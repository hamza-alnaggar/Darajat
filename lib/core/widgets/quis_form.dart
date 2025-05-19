import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/widgets/app_text_button_2.dart';
import 'package:learning_management_system/core/widgets/text_form_field_2.dart';

class QuizForm extends StatefulWidget {
  const QuizForm({super.key});

  @override
  _QuizFormState createState() => _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  final TextEditingController _questionController = TextEditingController();
  int _correctIndex = 0;
  final List<TextEditingController> _answerControllers = [];
  final List<int> _explainLimits = [];

  @override
  void initState() {
    super.initState();
    // initialize with three answer slots
    for (var i = 0; i < 3; i++) {
      _addAnswerField();
    }
  }

  void _addAnswerField() {
    _answerControllers.add(TextEditingController());
    _explainLimits.add(600);
  }

  void _removeAnswerField(int index) {
    if (_answerControllers.length <= 1) return;
    setState(() {
      _answerControllers[index].dispose();
      _answerControllers.removeAt(index);
      _explainLimits.removeAt(index);
      if (_correctIndex >= _answerControllers.length) {
        _correctIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            TextFormField2(
              minLines: 5,
              controller: _questionController,
            ),
            SizedBox(height: 10.h),
            Text('Answers', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _answerControllers.length,
              itemBuilder: (context, index) {
                return _buildAnswerTile(index);
              },
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 40.h,
                width: 100.w,
                child: AppTextButton2(
                  textStyle: TextStyle(fontSize: 20.r,color: Colors.white),
                  buttonText: "Save", onpressed: (){
                }),
              ),
            )
          ],
        ),
    );
  }

  Widget _buildAnswerTile(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<int>(
                value: index,
                groupValue: _correctIndex,
                onChanged: (val) {
                  setState(() {
                    _correctIndex = val!;
                  });
                },
              ),
              Expanded(
                child: TextFormField2(
                  minLines: 3,
                  controller: _answerControllers[index],
                  
                    hint: 'Add an answer.',
                    
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                child: Icon(
                  Icons.delete_outline),
                  onTap: () => _removeAnswerField(index),
              ),
            ],
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child:SizedBox(
              width: 200.w,
              child: TextFormField2(
                    //minLines: 3,
                    //controller: _answerControllers[index],
                      hint: 'Explain why this ',
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var c in _answerControllers) {
      c.dispose();
    }
    super.dispose();
  }
}

