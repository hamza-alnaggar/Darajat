import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/teacher/screens/create_episodes_screen.dart';
import 'package:learning_management_system/features/teacher/widget/build_media_item.dart';
import 'package:path/path.dart' as path;

class VideoList extends StatelessWidget {
  final Lecture lecture;
  final bool isDark;
  final String status;
  final VoidCallback onRemoveVideo;
  final VoidCallback onRemoveThumbnail;
  final VoidCallback onRemovePdf;
  final VoidCallback onReplaceVideo;
  final VoidCallback onReplacePdf;
  final VoidCallback onReplaceImage;
  

  const VideoList({
    required this.lecture,
    required this.isDark,
    required this.status,
    required this.onReplacePdf,
    required this.onRemoveVideo,
    required this.onRemoveThumbnail,
    required this.onRemovePdf,
    required this.onReplaceImage,
    required this.onReplaceVideo,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];

    if (lecture.videoFile != null) {
      items.add(buildMediaItem(
        status:status,
        color:  Colors.redAccent,onReplace: onReplaceVideo,
        fileName: "Video", icon: Icons.videocam,
        isDark: isDark, onRemove: onRemoveVideo,
        type: path.basename(lecture.videoFile!.path),
      ));
    }
    if (lecture.imageFile != null) {
      items.add(buildMediaItem(
      fileName:  "Thumbnail",
              status:status,

      isDark: isDark,
      icon:  Icons.image,
      onReplace: onReplaceImage,
      color:  Colors.blueAccent,
      type:   path.basename(lecture.imageFile!.path),
      onRemove:   onRemoveThumbnail,
      ));
    }
    if (lecture.pdfFile != null) {
      items.add(buildMediaItem(
      fileName:   "PDF",
              status:status,

      isDark: isDark,
      onReplace: onReplacePdf,
      icon:   Icons.picture_as_pdf,
      color:   Colors.orange,
      type:   path.basename(lecture.pdfFile!.path),
      onRemove:  onRemovePdf,
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          if (items.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Uploaded now",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    "${items.length} files",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ...items,
          if (items.isEmpty)
            
            Center(
                child: Text(
                  "No new files uploaded yet",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ),
          
        ],
      ),
    );
  }}