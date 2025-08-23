// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:learning_management_system/features/teacher/screens/create_course.dart';

// class QuizEditor extends StatefulWidget {
//   final Quiz quiz;
//   final Function(String, String) onSave;

//   const QuizEditor({
//     required this.quiz,
//     required this.onSave,
//   });

//   @override
//   __QuizEditorState createState() => __QuizEditorState();
// }

// class __QuizEditorState extends State<QuizEditor> {
//   late TextEditingController _titleController;
//   late TextEditingController _descController;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.quiz.name);
//     _descController = TextEditingController(text: widget.quiz.description);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: _titleController,
//           style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             labelText: 'Quiz Title',
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           )),
//         SizedBox(height: 12.h),
//         Text(
//           'Quiz Description',
//           style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
//         ),
//         SizedBox(height: 8.h),
//         TextFormField(
//           controller: _descController,
//           minLines: 2,
//           maxLines: 4,
//           decoration: InputDecoration(
//             hintText: 'Describe what this quiz covers...',
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         )),
//         SizedBox(height: 16.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             TextButton(
//               onPressed: () => widget.onSave(_titleController.text, _descController.text),
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.deepPurpleAccent,
//                 padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//               )),
//               child: Text(
//                 'Save Quiz',
//                 style: TextStyle(color: Colors.white, fontSize: 14.sp),
//               ),
//             ),
//         ],
//         ),
//       ],
//     );
//   }
// }