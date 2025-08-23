import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/create_episode_body_model.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/episodes_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_episode_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_update_episode_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episode_list_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/inline_video_player.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/sub_models/question_sub_models.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_cubit.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_state.dart';
import 'package:learning_management_system/features/teacher/is_changed_cubit.dart';
import 'package:learning_management_system/features/teacher/widget/add_content_button.dart';
import 'package:learning_management_system/features/teacher/widget/content_type_selector.dart';
import 'package:learning_management_system/features/teacher/widget/content_uploader.dart';
import 'package:learning_management_system/features/teacher/widget/full_image_viewer.dart';
import 'package:learning_management_system/features/teacher/widget/lecture_editor.dart';
import 'package:learning_management_system/features/teacher/widget/media_display_section.dart';
import 'package:learning_management_system/features/teacher/widget/quiz_card.dart';
import 'package:learning_management_system/features/teacher/widget/video_list.dart';

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
    this.addContent = true,
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

    context.read<EpisodesListCubit>().getEpisodes(widget.courseId,widget.isCopy);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _showExitConfirmation();
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content: Text('You have unsaved changes. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add any cleanup logic here if needed
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _addLecture() => setState(() {
    _lectures.add(Lecture(title: 'Lecture ${_lectures.length + 1}'));
  });

  void _deleteLecture(Lecture lecture) {
    if (lecture.episode != null) {
      context.read<CreateUpdateEpisodeCubit>().deleteEpisode(
        lecture.episode!.id,
        widget.isCopy
      );
    }
    setState(() => _lectures.remove(lecture));
  }

  void _saveLecture(Lecture lecture) async {
    if (lecture.episode == null &&
        (lecture.videoFile == null || lecture.imageFile == null || lecture.pdfFile == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no change to do')),
      );
      return;
    }

    final request = CreateEpisodeBodyModel(
      title: lecture.title,
      episodeNumber: _lectures.indexOf(lecture) + 1,
      videoFile: lecture.videoFile!,
      imageFile: lecture.imageFile!,
      pdfFile: lecture.pdfFile
    );
    if (lecture.episode == null) {
      await context.read<CreateUpdateEpisodeCubit>().createEpisode(
        courseId: widget.courseId,
        request: request,
        isCopy:  widget.isCopy
      );
    } else {
      context.read<CreateUpdateEpisodeCubit>().updateEpisode(
        episodeId: lecture.episode!.id,
        request: request,
        isCopy:  widget.isCopy
      );
    }
  }

  Future<void> _pickPdf(Lecture lecture) async {
    if(lecture.pdfFile != null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('you will replace the file')),
      );
    }
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

  void _removePdf(Lecture lecture) {
    setState(() {
      lecture.pdfFile = null;
    });
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
  void _toggleLectureAddPdf(Lecture lecture) {
    setState(() => lecture.addPdf = !lecture.addPdf);
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
            context.read<IsChangedCubit>().isChanged = true;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.read<EpisodesListCubit>().getEpisodes(widget.courseId,widget.isCopy);
            } else if (state is EpisodeFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.errMessage}')),
              );
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
          return Center(child: CircularProgressIndicator());
        } else if (state is EpisodesListError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: _lectures.length,
            itemBuilder: (context, index) {
              final lecture = _lectures[index];
              if (lecture.episode != null) {
                return MultiBlocProvider(
                    providers: [
                        BlocProvider(
                                  key: ValueKey('episode_//${lecture.episode?.id ?? 'new_$index'}'),
                                  create: (context) => EpisodeDetailCubit(
                                    repository: sl<EpisodesRepository>(),
                                    isStudent: false,
                                  ),
                                ),
                        BlocProvider(key: ValueKey('quiz//${lecture.episode?.id ?? 'newQuiz$index'}'),create: (context) => sl<QuizCreationCubit>()),
                    ],
                                      child: _buildLectureCard(lecture, isDark, theme,widget.status),
                );
              } else {
                return _buildLectureCard(lecture, isDark, theme,widget.status);
              }
            },
          );
        }
      },
    );
  }



  Widget _buildLectureCard(Lecture lecture, bool isDark, TextTheme theme,String status) {
    return Column(
      key: ValueKey(lecture),
      children: [
        _LectureCard(
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

class _LectureCard extends StatefulWidget {
  final Lecture lecture;
  final EpisodeModel? episodeModel;
  final bool isDark;
  final TextTheme theme;
  final bool isCopy;
  final String status;
  final VoidCallback onEdit;
  final VoidCallback onAddContent;
  final VoidCallback onAddVideo;
  final VoidCallback onAddPdf;
  final VoidCallback onShowVideo;
  final Future<void> Function() onPickPdf;
  final VoidCallback onRemovePdf;
  final VoidCallback onDelete;
  final VoidCallback onSave;
  final Future<void> Function() onPickVideo;
  final Future<void> Function() onPickImage;
  final VoidCallback onRemoveVideo;
  final VoidCallback onRemoveThumbnail;

  const _LectureCard({
    required this.lecture,
    required this.isDark,
    required this.isCopy,
    required this.status,
    required this.theme,
    required this.onEdit,
    required this.onAddContent,
    required this.onPickPdf,  
    required this.onAddVideo,
    required this.onAddPdf,
    required this.onRemovePdf,      
    required this.onShowVideo,
    required this.onDelete,
    required this.onSave,
    required this.episodeModel,
    required this.onPickVideo,
    required this.onPickImage,
    required this.onRemoveVideo,
    required this.onRemoveThumbnail,
  });

  @override
  State<_LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<_LectureCard>with AutomaticKeepAliveClientMixin  {
  bool _showVideoPlayer = false;
  bool _showFullImage = false;
  Uint8List? _fullImageBytes;
  Stream<Uint8List>? _fullVideoBytes;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    if (widget.episodeModel != null) {
      _loadMedia();
    }
  }
  Future<void> onUpdateVideo() async {
  await widget.onPickVideo(); 
  
}

Future<void> onUpdateImage() async {
  await widget.onPickImage(); 
  
}

Future<void> onUpdatePdf() async {
  await widget.onPickPdf(); 
  
}

  Future<void> _loadMedia() async {
    if (widget.episodeModel != null) {
      try {
        final cubit = context.read<EpisodeDetailCubit>();
        await cubit.loadEpisodeMedia(widget.episodeModel!.id,false,widget.isCopy);
        _fullImageBytes = cubit.poster;
        _fullVideoBytes = cubit.videoStream;
        setState(() {});
      } catch (e) {
        print('Error loading media: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCreationCubit, QuizCreationState>(
    listener: (context, state) {
      if (state is QuizCreationFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      else if (state is QuizCreationSuccess) {
      context.read<IsChangedCubit>().isChanged = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت العملية بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDark ? CustomColors.darkContainer : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          initiallyExpanded: true,
          leading: Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: Colors.blue.shade100.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_circle_outline,
              color: CustomColors.primary2,
              size: 20.r,
            ),
          ),
          title: widget.lecture.isEditing
              ? LectureEditor(lecture: widget.lecture)
              : Text(
                  widget.lecture.title,
                  style: widget.theme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
          subtitle:  widget.lecture.isEditing
              ? null
              : Text(
                  'Episode ${widget.lecture.episode?.episodeNumber ?? ''}',
                  style: widget.theme.bodyMedium?.copyWith(
                    color: widget.isDark
                        ? Colors.white70
                        : Colors.grey.shade600,
                  ),
                ),
          trailing:widget.status !='approved' ?widget.lecture.isEditing
              ? IconButton(
                  icon: Icon(
                    Icons.save,
                    size: 20.r,
                    color: CustomColors.primary2,
                  ),
                  onPressed: widget.onEdit,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20.r,
                        color: widget.isDark
                            ? Colors.white70
                            : Colors.grey.shade700,
                      ),
                      onPressed: widget.onEdit,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20.r,
                        color: widget.isDark
                            ? Colors.white70
                            : Colors.grey.shade700,
                      ),
                      onPressed: widget.onDelete,
                    ),
                  ],
                ):null,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  if (widget.episodeModel == null) ...[
                    if (widget.lecture.addVideo || widget.lecture.addPdf) ...[
                      ContentTypeSelector(
                        isDark: widget.isDark,
                        onVideoSelected: widget.onAddVideo,
                        onPdfSelected: widget.onAddPdf,
                        onClose: widget.onAddContent,
                      ),
                      SizedBox(height: 10.h,),
                      ContentUploader(
                        isDark: widget.isDark,
                        lecture: widget.lecture,
                        onPickVideo: widget.onPickVideo,
                        onPickImage: widget.onPickImage,
                        onClosePdf: widget.onAddPdf,
                        isVideo: widget.lecture.addVideo,
                        onCloseVideo: widget.onAddVideo,
                        onShowFiles: widget.onShowVideo,
                        onPickPdf: widget.onPickPdf,
                      ),
                      SizedBox(height: 10.h,)
                    ],
                    if (!widget.lecture.addContent &&
                        !widget.lecture.addVideo
                        ) ...[
                      AddContentButton(
                        onPressed: widget.onAddContent,
                        isDark: widget.isDark,
                      ),
                      SizedBox(height: 10.h,)
                    ],
                  ],
                  if (widget.episodeModel != null) ...[
                    SizedBox(height: 16.h),
                    MediaDisplaySection(
                      onPickImage :onUpdateImage,
                      onPickPdf:onUpdatePdf ,
                      onPickVideo: onUpdateVideo,
                      hasVideo: _fullVideoBytes != null,
                      hasImage: _fullImageBytes != null,
                      hasPdf: widget.lecture.pdfFile != null,
                      isDark: widget.isDark,
                      onShowVideo: () => setState(() => _showVideoPlayer = !_showVideoPlayer),
                      onShowImage: () => setState(() => _showFullImage = true),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  
                  if (_showVideoPlayer && _fullVideoBytes != null)
                    InlineVideoPlayer(
                      key: ValueKey(widget.episodeModel!.id),
                      episode:widget.episodeModel!,
                      showExtraInfol: true,
                      isCopy:widget.isCopy,
                      isStudent: false,
                    ),
                    SizedBox(height: 10.h,),
                    
                  if (_showFullImage && _fullImageBytes != null)
                    FullImageViewer(
                      imageBytes: _fullImageBytes!,
                      onClose: () => setState(() => _showFullImage = false),
                    ),
                    if (widget.lecture.showVideoUpload) 
                      VideoList(
                        lecture: widget.lecture,
                        isDark: widget.isDark,
                        status:widget.status,
                        onReplaceImage: widget.onPickImage,
                        onReplacePdf: widget.onPickPdf,
                        onReplaceVideo: widget.onPickVideo,
                        onRemoveVideo: widget.onRemoveVideo,
                        onRemovePdf: widget.onRemovePdf,
                        onRemoveThumbnail: widget.onRemoveThumbnail,
                      ),
                      SizedBox(height: 20.h,),
                      actionButton(widget.lecture.episode == null ? 'Create episode' : 'Update episode',widget.onSave ),
                  if (widget.lecture.quiz != null)
                  QuizCard(
                    episodeId: widget.lecture.episode!.id,
                    quiz: widget.lecture.quiz!,
                    status:widget.status,
                    isDark: widget.isDark,
                    theme: widget.theme,
                    onDelete: (quizId) {
                      if (quizId != null) {
                        context.read<QuizCreationCubit>().deleteQuiz(quizId,false);
                      }
                      setState(() => widget.lecture.quiz = null);
                    },
                    onAddQuiz: () {
                      setState(() => widget.lecture.quiz = Quiz.newQuiz());
                    },
                    onQuizUpdated: (updatedQuiz) {
                    },
                  ),
                  SizedBox(height: 10.h,),
                
                if (widget.lecture.episode!= null && widget.lecture.quiz == null)
                actionButton('Create Quiz',()=>
                setState(() => widget.lecture.quiz = Quiz.newQuiz()),
                ),
                if (widget.lecture.episode == null)
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      'Create the episode first to add a quiz',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                
                SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton actionButton(String action,VoidCallback onPressed) {
    return ElevatedButton(
                              onPressed: onPressed,
                            
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.isDark 
                                    ? Colors.deepPurple.shade800 
                                    : Colors.deepPurpleAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 20.r),
                                  SizedBox(width: 8.w),
                                  Text(action, style: TextStyle(fontSize: 14.sp)),
                                ],
                              ),
                            );
  }

}
