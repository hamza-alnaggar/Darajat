// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/core/widgets/app_text_button_2.dart';
import 'package:learning_management_system/core/widgets/quis_form.dart';
import 'package:learning_management_system/core/widgets/table.dart';
import 'package:learning_management_system/core/widgets/text_form_field_2.dart';

// Models
class Lecture {
  String title;
  String name;
  bool isEditing ;
  bool addContent;
  bool addVideo;
  bool showVideoUpload;
  bool addLecture;
  Lecture({required this.title,required this.name, this.isEditing = false,this.addContent = false,this.addLecture = false,this.addVideo = false,this.showVideoUpload = false});
}
class Quiz {
  String title;
  String name;
  String description;
  bool isEditing;
  bool addQuestion;
  List<Question> questions;

  Quiz({
    required this.title,
    required this.name,
    required this.description,
    this.addQuestion = false,
    this.isEditing = false,
    List<Question>? questions,
  }) : questions = questions ?? [];
}
class Question {
  String questionText;
  List<String> answers;
  int correctIndex;
  List<String> explanations;

  Question({
    required this.questionText,
    required this.answers,
    required this.correctIndex,
    required this.explanations,
  });
}


class Section {
  String title;
  String name;
  String objective;
  List<Lecture> lectures;
  List <Quiz> ?quizs;
  bool isEditing;

  Section({
    required this.title,
    required this.name,
    this.objective = '',
    List<Lecture>? lectures,
    this. quizs,
    this.isEditing = false,
  }) : lectures = lectures ?? [] ;
}

class SectionBuilderPage extends StatefulWidget {
  const SectionBuilderPage({super.key});

  @override
  _SectionBuilderPageState createState() => _SectionBuilderPageState();
}

class _SectionBuilderPageState extends State<SectionBuilderPage> {
 
  List<Map<String, String>> videos = [];

  // In _SectionBuilderPageState
void _toggleQuizEdit(Quiz quiz) {
  setState(() => quiz.isEditing = !quiz.isEditing);
}
void _toggleAddQuestion(Quiz quiz) {
  setState(() => quiz.addQuestion = !quiz.addQuestion);
}

void _addQuiz(Section section) {
  setState(() {
    section.quizs ??= [];
    section.quizs!.add(Quiz(
      name: 'quiz name',
      title: 'Quiz ${section.quizs!.length+1}',
      description: 'Description',
    ));
  });
}

void _saveQuiz(Quiz quiz, String newTitle, String newDesc) {
  setState(() {
    quiz.title = newTitle;
    quiz.description = newDesc;
    quiz.isEditing = false;
  });
}

// Future<void> _addQuestionToQuiz(Quiz quiz) async {
//   final question = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => QuizForm()),
//   );
//   if (question != null) {
//     setState(() => quiz.questions.add(question));
//   }
// }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) return;

    final file = result.files.single;
    setState(() {
      videos.add({
        'filename': file.name,
        'type': 'Video',
        'status': 'Uploaded', // or your custom status
        'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      });
    });
  }
  final
  List<Section> _sections = [Section(title: 'Section 1:',name: 'section name', lectures: [Lecture(title: 'Lecture 1',name: 'lecture name')])];

  void _toggleEdit(Section section) {
    setState(() => section.isEditing = !section.isEditing);
  }

  void _toggleLectureEdit(Lecture lecture) {
    setState(() => lecture.isEditing = !lecture.isEditing);
  }
  void _toggleLectureAddContent(Lecture lecture) {
    setState(() => lecture.addContent = !lecture.addContent);
  }
  void _toggleLectureAddVideo(Lecture lecture) {
    setState(() => lecture.addVideo = !lecture.addVideo);
  }
  void _toggleLectureShowVideoUploade(Lecture lecture) {
    setState(() => lecture.showVideoUpload = !lecture.showVideoUpload);
  }

  void _saveSection(Section section, String newTitle, String newObj) {
    setState(() {
      section.title = newTitle;
      section.objective = newObj;
      section.isEditing = false;
    });
  }

  void _addSection() => setState(() => _sections.add(Section(title: 'Section ${_sections.length+1}:',name: 'section name')));
  void _addLecture(Section section) => setState(() => section.lectures.add(Lecture(name: 'lecutre name',title: 'Lecture ${section.lectures.length+1}:')));





  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      //appBar: AppBar(title: const Text('')),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 25.w,vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReorderableListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final sec = _sections.removeAt(oldIndex);
                      _sections.insert(newIndex, sec);
                    });
                  },
                  children: _sections.map((section) {
                    return Column(
                      key: ValueKey(section),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: CustomColors.containerSecondColor,
                            border: Border.all(color: CustomColors.dark)
                          ),
                          key: ValueKey(section),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child:  _buildSectionView(section,theme),
                          ),
                        ),
                        //_buildQuizEditor(null, true, section),
                        SizedBox(width: double.infinity,child: OutlinedButton(onPressed: (){
                  _addQuiz(section);
                },style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: CustomColors.primary2))), child: Text("+ Quiz",),)),
                SizedBox(height: 10.h,),
                SizedBox(width: double.infinity,child: OutlinedButton(onPressed: (){
                  _addLecture(section);
               },style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: CustomColors.primary2))), child: Text("+ Lecture"),))
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.h,),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CustomColors.primary2
        ),
        child: IconButton(onPressed: (){
          _addSection();
        }, icon: Icon(Icons.add)),
      ),
    );
  }

  Widget _buildSectionView(Section section,TextTheme theme) {
    
    return 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      section.isEditing?
    _buildSectionEditor(section): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(section.title, style: theme.headlineSmall)),
                GestureDetector(child: Icon( Icons.edit_outlined,size: 20.r,), onTap: () => _toggleEdit(section)),
                SizedBox(width: 10.h,),
                GestureDetector(child: Icon(Icons.delete_outline,size: 20.r,), onTap: () {}),
              ],
            ),
            SizedBox(height: 7.h,),
            Row(
          children: [
            Icon(Icons.description_outlined,size: 20.r,),
            SizedBox(width: 5.w,),
            Text(section.name,style: theme.bodyMedium,)
          ],
        ),
          ],
        ),
        SizedBox(height: 30.h,),
      ...section.lectures.map((lec) => _buildLectureView(lec, theme)),
    if (section.quizs != null) ...section.quizs!.map((quiz) => _buildQuizView(quiz, section,theme)),
]);
  }

  Container _buildLectureView(Lecture lec, TextTheme theme) {
    return Container(
      
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black)
      ),
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child:!lec.isEditing? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Row(
                  children: [
                    Icon(Icons.check_circle,size: 20.r,),
                    SizedBox(width: 5.w,),
                    Text(lec.title, style: theme.bodyLarge?.copyWith(fontSize: 17.sp)),
                  ],
                )),
                GestureDetector(child: Icon( Icons.edit_outlined,size: 20.r,), onTap: () => _toggleLectureEdit(lec)),
                SizedBox(width: 10.w,),
                GestureDetector(child: Icon(Icons.delete_outline,size: 20.r,), onTap: () {}),
              ],
            ),
            SizedBox(height: 7.h,),
            Row(
          children: [
            Icon(Icons.description_outlined,size: 20.r,),
            SizedBox(width: 5.w,),
            Text(lec.name,style: theme.bodyMedium,)
          ],
        ),
        SizedBox(height: 10.h,),
      !lec.addContent? SizedBox(
          child: SizedBox(
            height: 40.h,
            child: OutlinedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7), // Radius here
    ),
  ),
                side:WidgetStatePropertyAll(BorderSide(color: CustomColors.primary2,width: 1))
              ),
              onPressed: (){
                _toggleLectureAddContent(lec);
            }, child:
                Text("+ content",style: theme.bodyLarge
                ?.copyWith(color: CustomColors.primary2),)
              ),
          ),
        ):lec.showVideoUpload ? DataTablePage(rows: videos): lec.addVideo ?_buildLectureAddVideo(theme,lec): _buildLectureAddContent(theme,lec)
          ],
        ):_buildLectureEditor(lec),
      ), 
            );
  }
  

  Widget _buildLectureAddContent(TextTheme theme,Lecture lec){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.dark)
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical:20.h ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select content type",
                  style:theme.headlineSmall,
                ),
                SizedBox(width: 10.h,),
                IconButton(icon:Icon(Icons.close),iconSize: 19.r,onPressed: (){
                  _toggleLectureAddContent(lec);
                },)
              ],
            ),
            SizedBox(height: 20.h,),
            Text("Select the main type of content\n Files and links can be added as\n resources",style: theme.bodyMedium,),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(child: containerContentTypeOfLecture(Icons.play_circle,"Video"),onTap: (){
                  _toggleLectureAddVideo(lec);
                },),
                SizedBox(width: 20.w,),
                containerContentTypeOfLecture(Icons.description,"Article"),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildQuizView(Quiz quiz, Section section,TextTheme theme) {

  return Container(

    margin: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color:CustomColors.dark),
    ),
    child: Padding(
      padding: EdgeInsets.all(8),
      child: quiz.isEditing 
          ? _buildQuizEditor(quiz,false,section)
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                    Icon(Icons.check_circle,size: 20.r,),
                    SizedBox(width: 5.w,),
                    Text(quiz.title, style: theme.headlineSmall),
                      ],
                    ),
                  ),
                  GestureDetector(child: Icon( Icons.edit_outlined,size: 20.r,), onTap: () =>  _toggleQuizEdit(quiz)),
                SizedBox(width: 10.w,),
                GestureDetector(child: Icon(Icons.delete_outline,size: 20.r,), onTap: () {}),
                ],
              ),
              SizedBox(height: 5.h,),
              Row(
          children: [
            Icon(Icons.question_mark_rounded,size: 20.r,),
            SizedBox(width: 5.w,),
            Text(quiz.name,style: theme.bodyMedium,)
          ],
        ),
        SizedBox(height:10.h ,),
                ...quiz.questions.map((q) => Text(q.questionText)),
              quiz.addQuestion?QuizForm(): OutlinedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7), // Radius here
    ),
  ),
                side:WidgetStatePropertyAll(BorderSide(color: CustomColors.primary2,width: 1))
              ),
              onPressed: (){
                _toggleAddQuestion(quiz);
            }, child:
                Text("+ Questions",style: theme.bodyLarge
                ?.copyWith(color: CustomColors.primary2),)
              ),
              ],
            ),
    ),
  );
}

  Widget _buildLectureAddVideo(TextTheme theme,Lecture lec){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.dark)
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical:20.h ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Upload Video",
                  style:theme.headlineSmall,
                ),
                SizedBox(width: 10.h,),
                IconButton(icon:Icon(Icons.close),iconSize: 19.r,onPressed: (){
                  
                  _toggleLectureAddVideo(lec);
                },)
              ],
            ),
            SizedBox(height: 20.h,),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width:120.w ,child: OutlinedButton(onPressed: (){

                }, child:Text("No Files ad...") )),
                SizedBox(width: 10.h,),
                SizedBox(
                  width: 120.w,
                  child: OutlinedButton(style: ButtonStyle(
                    side: WidgetStatePropertyAll(BorderSide(color:  Colors.deepPurpleAccent))
                  ),onPressed: ()async{
                    await _pickVideo();
                  _toggleLectureShowVideoUploade(lec);
                  }, child: Text("Select Video",style: TextStyle(color: Colors.deepPurpleAccent),)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container containerContentTypeOfLecture(IconData icon,String title) {
    return Container(
            width: 80.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: CustomColors.grey.withOpacity(0.8),
              border: Border.all(color: Colors.grey)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(icon,color: CustomColors.darkGrey,),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: double.infinity,
                  color: CustomColors.darkGrey,
                  child: Center(child: Text(title)),
                )
              ],
            ),
          );
  }


Widget _buildQuizEditor(Quiz ?quiz,bool isNew,Section section) {
  final theme = Theme.of(context).textTheme;
  TextEditingController titleController = TextEditingController(text: quiz?.name);
  TextEditingController descController = TextEditingController(text: quiz?.description);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.check_circle,size: 20.r,),
          SizedBox(width: 5,),
          Text(isNew?'New Quiz':quiz!.title,style: theme.headlineSmall,),
        ],
      ),
      SizedBox(height: 10.h,),
      TextFormField2(
        controller: titleController,
        hint: "Enter a title",
        maxLength: 80,
      ),
      TextFormField2(
        controller: descController,
        hint: "Quiz Description",
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(CustomColors.dark),
                ),onPressed: () => _toggleQuizEdit(quiz!), child:  Text('Cancel',style: TextStyle(fontSize: 15.sp),),),
                
                SizedBox(
                  width: 115.w,
                  height: 40.h,
                  child: AppTextButton2(
                    textStyle: TextStyle(fontSize: 15.sp,color: Colors.white),
                    onpressed: () => _addQuiz(section),
                    buttonText: isNew?'Add Quiz':'Save Quiz',
                  ),
                ),
        ],
      ),
    ],
  );
}

  Widget _buildSectionEditor(Section section) {
    final theme = Theme.of(context).textTheme;
    final titleCtrl = TextEditingController(text: section.name);
    final objCtrl = TextEditingController(text: section.objective);
    return Container(
      decoration: BoxDecoration(border: Border.all(color: CustomColors.dark)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.title,style: theme.headlineSmall,),
            SizedBox(height: 10.h,),
            TextFormField2(
              hint: 'Enter a Title',
              controller: titleCtrl,
            ),
            const SizedBox(height: 8),
            Text('What will students be able to do at the end of this section?',style: theme.bodyLarge),
            SizedBox(height: 12.h),
            TextFormField2(
              controller: objCtrl,
                hint: 'Enter a Learning Objective',
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(CustomColors.dark),
                ),onPressed: () => _toggleEdit(section), child:  Text('Cancel',style: TextStyle(fontSize: 15.sp),),),
                
                SizedBox(
                  width: 115.w,
                  height: 40.h,
                  child: AppTextButton2(
                    textStyle: TextStyle(fontSize: 15.sp,color: Colors.white),
                    onpressed: () => _saveSection(section, titleCtrl.text, objCtrl.text),
                    buttonText: 'Save Section',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLectureEditor(Lecture lecture) {
        final theme = Theme.of(context).textTheme;
    final titleCtrl = TextEditingController(text: lecture.name);
   
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle,size: 20.r,),
                    SizedBox(width: 5.w,),
                    Text(lecture.title, style: theme.bodyLarge?.copyWith(fontSize: 17.sp)),
            ],
          ),
          SizedBox(height: 5.h,),
          TextFormField2(
            controller: titleCtrl,
            hint: "Enter a title",
            maxLength: 80,
          ),
          
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(CustomColors.dark),
                ),onPressed: () => _toggleLectureEdit(lecture), child:  Text('Cancel',style: TextStyle(fontSize: 15.sp),),),
                
            
              SizedBox(
                  width: 115.w,
                  height: 40.h,
                  child: AppTextButton2(
                    textStyle: TextStyle(fontSize: 15.sp,color: Colors.white),
                    onpressed: () {},
                    buttonText: 'Save Lecture',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

