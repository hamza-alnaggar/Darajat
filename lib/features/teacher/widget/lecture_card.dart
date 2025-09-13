import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/inline_video_player.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_cubit.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_state.dart';
import 'package:learning_management_system/features/teacher/is_changed_cubit.dart';
import 'package:learning_management_system/features/teacher/screens/create_episodes_screen.dart';
import 'package:learning_management_system/features/teacher/widget/add_content_button.dart';
import 'package:learning_management_system/features/teacher/widget/content_type_selector.dart';
import 'package:learning_management_system/features/teacher/widget/content_uploader.dart';
import 'package:learning_management_system/features/teacher/widget/full_image_viewer.dart';
import 'package:learning_management_system/features/teacher/widget/lecture_editor.dart';
import 'package:learning_management_system/features/teacher/widget/media_display_section.dart';
import 'package:learning_management_system/features/teacher/widget/quiz_card.dart';
import 'package:learning_management_system/features/teacher/widget/video_list.dart';
import 'package:learning_management_system/generated/l10n.dart';

class LectureCard extends StatefulWidget {
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

  const LectureCard({
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
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard>with AutomaticKeepAliveClientMixin  {
  bool _showVideoPlayer = false;
  bool _showFullImage = false;
  bool _isDeletingQuiz = false;

  Uint8List? _fullImageBytes;
  Stream<Uint8List>? _fullVideoBytes;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    if (widget.episodeModel != null) {
      _loadMedia();;
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
 Future<void> _handleDeleteQuiz(int? quizId) async {
    if (quizId == null)
    {
        setState(() => widget.lecture.quiz = null);
    return;}
    if (_isDeletingQuiz) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomColors.backgroundColor,
        title: const Text('Delete quiz?'),
        content: const Text('Are you sure you want to delete this quiz?'),
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

    if (confirmed != true) return;

    setState(() => _isDeletingQuiz = true);

    try {
      final success = await context.read<QuizCreationCubit>().deleteQuiz(
            quizId,
            widget.status == 'approved' || widget.status == 'rejected',
          );

      if (success) {
        setState(() => widget.lecture.quiz = null);

      } else {

        _showSnackBar(
          context,
          message: 'Failed to delete quiz',
          contentType: ContentType.failure,
          title: 'Error !',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      _showSnackBar(
        context,
        message: 'Error deleting quiz: $e',
        contentType: ContentType.failure,
        title: 'Error !',
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isDeletingQuiz = false);
    }
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
          _showSnackBar(context, message: state.errMessage, contentType: ContentType.failure, title: 'Error !', backgroundColor:Colors.red);

      }
      else if (state is QuizCreationSuccess) {
      _showSnackBar(context, message: state.message, contentType: ContentType.success, title: 'Success !', backgroundColor: CustomColors.primary);

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
          shape: Border.all(width: 0),
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
      if (widget.episodeModel != null) ...[
        MediaDisplaySection(
          onPickImage: onUpdateImage,
          onPickPdf: onUpdatePdf,
          status: widget.status,
onDeletePdf: widget.onRemovePdf ,
          onPickVideo: onUpdateVideo,
          hasVideo: _fullVideoBytes != null,
          hasImage: _fullImageBytes != null,
          hasPdf: widget.episodeModel!.hasFile!,
          isDark: widget.isDark,
          onShowComments: () {
          context.pushNamed(Routes.commentScreen,arguments: widget.episodeModel!.id);
          },
          onShowVideo: () => setState(() => _showVideoPlayer = !_showVideoPlayer),
          onShowImage: () => setState(() => _showFullImage = true),
        ),
        SizedBox(height: 16.h),

        if (_showVideoPlayer && _fullVideoBytes != null) ...[
          InlineVideoPlayer(
            key: ValueKey(widget.episodeModel!.id),
            episode: widget.episodeModel!,
            isCopy: widget.isCopy,
            isStudent: false,
          ),
          SizedBox(height: 10.h),
        ],

        if (_showFullImage && _fullImageBytes != null)
          FullImageViewer(
            imageBytes: _fullImageBytes!,
            onClose: () => setState(() => _showFullImage = false),
          ),
      ],

      if (widget.episodeModel == null) ...[
        if (widget.lecture.addVideo || widget.lecture.addPdf || widget.lecture.addContent) ...[
          ContentTypeSelector(
            isDark: widget.isDark,
            onVideoSelected: widget.onAddVideo,
            onPdfSelected: widget.onAddPdf,
            onClose: widget.onAddContent,
          ),
          SizedBox(height: 10.h),
          if(widget.lecture.addVideo || widget.lecture.addPdf )
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
          SizedBox(height: 10.h),
        ],

        if (!widget.lecture.addContent && !widget.lecture.addVideo) ...[
          AddContentButton(
            onPressed: widget.onAddContent,
            isDark: widget.isDark,
          ),
          SizedBox(height: 20.h),
        ],
      ],

      if (widget.lecture.showVideoUpload)
        VideoList(
          lecture: widget.lecture,
          isDark: widget.isDark,
          status: widget.status,
          onReplaceImage: widget.onPickImage,
          onReplacePdf: widget.onPickPdf,
          onReplaceVideo: widget.onPickVideo,
          onRemoveVideo: widget.onRemoveVideo,
          onRemovePdf: widget.onRemovePdf,
          onRemoveThumbnail: widget.onRemoveThumbnail,
        ),
        SizedBox(height: 20.h,),

      // زر الحفظ/التحديث
      if (widget.status != 'approved')
        actionButton(
          widget.lecture.episode == null ? 'Create episode' : 'Update episode',
          widget.onSave,
        ),
        SizedBox(height: 20.h,),

      // قسم الاختبارات
      if (widget.lecture.quiz != null)
        QuizCard(
          episodeId: widget.lecture.episode!.id,
          quiz: widget.lecture.quiz!,
          status: widget.status,
          isDark: widget.isDark,
          theme: widget.theme,
          onDelete:  (quizId) {
    _handleDeleteQuiz(quizId);
  },
          onAddQuiz: () {
            setState(() => widget.lecture.quiz = Quiz.newQuiz());
          },
          onQuizUpdated: (updatedQuiz) {},
        ),

      // أزرار إضافة الاختبار
      if (widget.lecture.episode != null && widget.lecture.quiz == null)
        actionButton(
          'Create Quiz',
          () => setState(() => widget.lecture.quiz = Quiz.newQuiz()),
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
        SizedBox(height: 10.h,),
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
              