import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/teacher/screens/create_episodes_screen.dart';
import 'package:learning_management_system/features/teacher/widget/upload_button.dart';

class ContentUploader extends StatelessWidget {
  final bool isDark;
  final Lecture lecture;
  final Future<void> Function() onPickVideo;
  final Future<void> Function() onPickImage;
  final Future<void> Function() onPickPdf;
  final VoidCallback onCloseVideo;
  final VoidCallback onClosePdf;
  final VoidCallback onShowFiles;
  final bool isVideo;

  const ContentUploader({
    required this.isDark,
    required this.lecture,
    required this.onPickVideo,
    required this.onPickImage,
    required this.onPickPdf,
    required this.onCloseVideo,
    required this.onClosePdf,
    required this.onShowFiles,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upload Lecture Content",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20.r,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                ),
                onPressed:isVideo? onCloseVideo : onClosePdf,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(isVideo)
              UploadButton(
                icon: Icons.video_file,
                label:lecture.videoFile == null ? "Video": 'Replace video',
                color: Colors.redAccent,
                onPressed: () async {
                  await onPickVideo();
                  onShowFiles();
                },
              ),
              if(isVideo)
              UploadButton(
                icon: Icons.image,
                label:lecture.imageFile == null ? "Thumbnail" : 'Replace thumbnail',
                color: Colors.blueAccent,
                onPressed: () async {
                  await onPickImage();
                  onShowFiles();
                },
              ),
              if(!isVideo)
              UploadButton(
                icon: Icons.picture_as_pdf,
                label:lecture.pdfFile == null ? "pdf" : 'Replace pdf',
                color: Colors.orange,
                onPressed: () async {
                  await onPickPdf();
                  onShowFiles();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
