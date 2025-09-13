import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/create_episode_body_model.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/episodes_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_episode_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_update_episode_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episode_list_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/sub_models/question_sub_models.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_cubit.dart';
import 'package:learning_management_system/features/teacher/widget/lecture_card.dart';
import 'package:learning_management_system/generated/l10n.dart';

import 'package:lottie/lottie.dart';

class Lecture {
  EpisodeModel? episode;
  String title;
  bool isEditing;
  bool addContent;
  bool addVideo;
  bool addPdf;
  bool showVideoUpload;
  File? videoFile;
  File? imageFile;
  File? pdfFile;
  Quiz? quiz;

  Lecture({
    this.episode,
    required this.title,
    this.isEditing = false,
    this.addContent = false,
    this.addVideo = false,
    this.addPdf = false,
    this.showVideoUpload = true,
    this.quiz,
  });

  factory Lecture.fromEpisode(EpisodeModel episode) {
    return Lecture(
      episode: episode,
      title: episode.title,
      isEditing: false,
      quiz: episode.quiz != null ? Quiz.fromQuizModel(episode.quiz!) : null,
    );
  }
}

class Quiz {
  int? quizId;
  bool addQuestion;
  QuestionSubModels? editingQuestion;
  List<QuestionSubModels> questions;

  Quiz({
    this.quizId,
    this.addQuestion = false,
    this.editingQuestion,
    List<QuestionSubModels>? questions,
  }) : questions = questions ?? [];

  Quiz copyWith({
    int? quizId,
    bool? addQuestion,
    QuestionSubModels? editingQuestion,
    List<QuestionSubModels>? questions,
  }) {
    return Quiz(
      quizId: quizId ?? this.quizId,
      addQuestion: addQuestion ?? this.addQuestion,
      editingQuestion: editingQuestion ,
      questions: questions ?? this.questions,
    );
  }

  factory Quiz.newQuiz() {
    return Quiz(
      addQuestion: true,
      questions: [],
    );
  }

  factory Quiz.fromQuizModel(QuizModel quizModel) {
    return Quiz(
      quizId: quizModel.quizId,
      questions: quizModel.questions,
    );
  }
}

class CreateEpisodesScreen extends StatefulWidget {
  final int courseId;
  final bool isCopy;
  final String status;

  const CreateEpisodesScreen({
    super.key,
    required this.courseId,
    required this.isCopy,
    required this.status,
  });

  @override
  _SectionBuilderPageState createState() => _SectionBuilderPageState();
}

class _SectionBuilderPageState extends State<CreateEpisodesScreen>with WidgetsBindingObserver {
  List<Lecture> _lectures = [];

  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addObserver(this);

    context.read<EpisodesListCubit>().getEpisodes(widget.courseId,widget.isCopy,false);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addLecture() => setState(() {
    _lectures.add(Lecture(title: 'Lecture ${_lectures.length + 1}'));
  });

  void _deleteLecture(Lecture lecture) async {
  if (lecture.episode == null) {
    setState(() => _lectures.remove(lecture));
    return;
  }

  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: CustomColors.backgroundColor,
      title: Text('Delete episode?'),
      content: Text('Are you sure you want to delete this episode?'),
      actions: [
        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                              Navigator.of(context).pop(false);

                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(S.of(context).Cancel),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                      Navigator.of(context).pop(true);
          },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(S.of(context).delete),
                            ),
                          ),
                        ],
                      ),
      ],
    ),
  );

  if (confirm != true) return;

  final cubit = context.read<CreateUpdateEpisodeCubit>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Lottie.asset('assets/images/loading.json'),
  );

  final success = await cubit.deleteEpisode(lecture.episode!.id, widget.isCopy);

  Navigator.of(context).pop();

  if (success) {
    setState(() => _lectures.remove(lecture));
    _showSnackBar(context,
      message: 'Episode deleted successfully',
      contentType: ContentType.success,
      title: 'Success !',
      backgroundColor: CustomColors.primary,
    );
    // context.read<EpisodesListCubit>().getEpisodes(widget.courseId, widget.isCopy);
  } else {
    
    _showSnackBar(context,
      message: 'Failed to delete episode',
      contentType: ContentType.failure,
      title: 'Error !',
      backgroundColor: Colors.red,
    );
  }
}


  void _saveLecture(Lecture lecture) async {

    final request = CreateEpisodeBodyModel(
      title: lecture.title,
      videoFile: lecture.videoFile,
      imageFile: lecture.imageFile,
      pdfFile: lecture.pdfFile
    );
    if (lecture.episode == null) {
      if(lecture.videoFile == null || lecture.imageFile == null)
        _showSnackBar(context, message: 'should upload video and image', contentType: ContentType.failure, title: 'Error !', backgroundColor: Colors.red) ;
      else
      {
        print('create');
        await context.read<CreateUpdateEpisodeCubit>().createEpisode(
        courseId: widget.courseId,
        request: request,
        isCopy:  widget.isCopy
      );
      }
    } else if(lecture.videoFile == null && lecture.imageFile == null && lecture.pdfFile == null ) {
        _showSnackBar(context, message: 'No change to update', contentType: ContentType.warning, title: 'Warning !', backgroundColor: Colors.orange) ;
    }
    else 
    { context.read<CreateUpdateEpisodeCubit>().updateEpisode(
        episodeId: lecture.episode!.id,
        request: request,
        isCopy:  widget.isCopy
      );}
    }


  Future<void> _pickPdf(Lecture lecture) async {
   
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    final file = File(result.files.single.path!);
    setState(() {
      lecture.pdfFile = file;
    });
  }

  void _removePdf(Lecture lecture) async {
  if (lecture.episode!.hasFile == false) {
    setState(() => lecture.pdfFile = null);
    return;
  }

  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: CustomColors.backgroundColor,
      title: Text('Delete PDF?'),
      content: Text('Are you sure you want to delete the PDF for this episode?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(S.of(context).Cancel),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(S.of(context).delete),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  if (confirm != true) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Lottie.asset('assets/images/loading.json'),
  );

  final success = await context.read<CreateUpdateEpisodeCubit>()
      .deleteEpisodeFile(lecture.episode!.id, widget.isCopy);

  Navigator.of(context).pop();

  if (success) {
    setState(() {
      lecture.pdfFile = null; 
      if (lecture.episode != null) {
        lecture.episode!.hasFile = false; 
      }
    });

    _showSnackBar(
      context,
      message: 'PDF deleted successfully',
      contentType: ContentType.success,
      title: 'Success !',
      backgroundColor: CustomColors.primary,
    );

    
  } else {
    _showSnackBar(
      context,
      message: 'Failed to delete PDF',
      contentType: ContentType.failure,
      title: 'Error !',
      backgroundColor: Colors.red,
    );
  }
}


  void _toggleLectureEdit(Lecture lecture) {
    setState(() => lecture.isEditing = !lecture.isEditing);
  }

  void _toggleLectureAddContent(Lecture lecture) {
    setState(() => lecture.addContent = !lecture.addContent);
  }

  void _toggleLectureAddVideo(Lecture lecture) {
    setState(
      (){ lecture.addVideo = !lecture.addVideo; lecture.addPdf = false;}
    );
  }
  void _toggleLectureAddPdf(Lecture lecture) {
    setState(() { lecture.addPdf = !lecture.addPdf; lecture.addVideo = false;});
  }
  void _toggleLectureShowVideoUpload(Lecture lecture) {
    setState(() => lecture.showVideoUpload = true);
  }
  Future<void> _pickVideo(Lecture lecture) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: true,
    );
    if (result == null) return;
    final file = File(result.files.single.path!);
    setState(() {
      lecture.videoFile = file;
    });
  }
  Future<void> _pickImage(Lecture lecture) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null) return;

    final file = File(result.files.single.path!);
    setState(() {
      lecture.imageFile = file;
    });
  }

  void _removeVideo(Lecture lecture) {
    setState(() {
      lecture.videoFile = null;
    });
  }

  void _removeThumbnail(Lecture lecture) {
    setState(() {
      lecture.imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    return MultiBlocListener(
      listeners: [
        BlocListener<EpisodesListCubit, EpisodesListState>(
          listener: (context, state) {
            if (state is EpisodesListLoaded) {
              setState(() {
                _lectures = state.response.data
                    .map((episode) => Lecture.fromEpisode(episode))
                    .toList();
              });
            }
          
          },
        ),
        BlocListener<CreateUpdateEpisodeCubit, EpisodeState>(
          listener: (context, state) {
            if (state is EpisodeSuccess) {
              context.pop();
              _showSnackBar(context, message: state.message, contentType: ContentType.success, title: 'Success !', backgroundColor: CustomColors.primary);
              context.read<EpisodesListCubit>().getEpisodes(widget.courseId,widget.isCopy,false);
            } else if (state is EpisodeFailure) {
              context.pop();
              _showSnackBar(context, message: state.errMessage, contentType: ContentType.failure, title: 'Error !', backgroundColor: Colors.red);

            }
            else if(state is EpisodeLoading){
              showDialog(barrierDismissible: false,context: context, builder:(context) => Lottie.asset('assets/images/loading.json'),);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: isDark
            ? CustomColors.backgroundColor
            : const Color(0xFFF8FAFD),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Manage Course',
                        style: theme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      if(widget.status!='approved')IconButton(
                        icon: Icon(
                          Icons.add,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        onPressed: _addLecture,
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildContent(isDark, theme)),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildContent(bool isDark, TextTheme theme) {
  return BlocBuilder<EpisodesListCubit, EpisodesListState>(
    builder: (context, state) {
      if (state is EpisodesListLoading) {
        return Center(child:Lottie.asset('assets/images/loading.json'));
      } else if (state is EpisodesListError) {
        return Center(child: Text('Error: ${state.message}'));
      } else {
        return _lectures.length !=0 ? ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: _lectures.length,
          itemBuilder: (context, index) {
            final lecture = _lectures[index];
            return MultiBlocProvider(
              providers: [
                if (lecture.episode != null)
                  BlocProvider(
                    key: ValueKey('episode_${lecture.episode?.id ?? 'new_$index'}'),
                    create: (context) => EpisodeDetailCubit(
                      repository: sl<EpisodesRepository>(),
                      isStudent: false,
                    ),
                  ),
                // Always provide QuizCreationCubit
                BlocProvider(
                  key: ValueKey('quiz_${lecture.episode?.id ?? 'newQuiz$index'}'),
                  create: (context) => sl<QuizCreationCubit>(),
                ),
              ],
              child: _buildLectureCard(lecture, isDark, theme, widget.status),
            );
          },
        ):_buildEmptyState();
      }
    },
  );
}
Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 100.r,
                color: CustomColors.primary
              ),
              SizedBox(height: 20.h),
              Text(
                'No episodes found',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
            ],
    );
  }



  Widget _buildLectureCard(Lecture lecture, bool isDark, TextTheme theme,String status) {
    return Column(
      key: ValueKey(lecture),
      children: [
        LectureCard(
          episodeModel: lecture.episode,
          lecture: lecture,
          isDark: isDark,
          theme: theme,
          status:status,
          isCopy:widget.isCopy,
          onShowVideo: () => _toggleLectureShowVideoUpload(lecture),
          onDelete: () => _deleteLecture(lecture),
          onSave: () => _saveLecture(lecture),
          onEdit: () => _toggleLectureEdit(lecture),
          onAddContent: () => _toggleLectureAddContent(lecture),
          onAddPdf: ()=>_toggleLectureAddPdf(lecture),
          onAddVideo: () => _toggleLectureAddVideo(lecture),
          onPickVideo: () => _pickVideo(lecture),
          onPickPdf: () => _pickPdf(lecture),
          onPickImage: () => _pickImage(lecture),
          onRemovePdf: () => _removePdf(lecture),
          onRemoveVideo: () => _removeVideo(lecture),
          onRemoveThumbnail: () => _removeThumbnail(lecture),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}


void _showSnackBar(
  BuildContext context, {
  required String message,
  required ContentType contentType,
  required String title,
  required Color backgroundColor,
}) {

final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    color: backgroundColor,
                    title: title,
                    message:
                        message,

                    contentType: contentType,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }
