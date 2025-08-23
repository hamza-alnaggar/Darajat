import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/teacher/screens/create_episodes_screen.dart';

class LectureEditor extends StatefulWidget {
  final Lecture lecture;

  const LectureEditor({required this.lecture});

  @override
  __LectureEditorState createState() => __LectureEditorState();
}

class __LectureEditorState extends State<LectureEditor> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.lecture.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      onChanged: (value) => widget.lecture.title = value,
      decoration: InputDecoration(
        labelText: 'Lecture Title',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}