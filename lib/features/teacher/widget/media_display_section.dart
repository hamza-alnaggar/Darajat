import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/teacher/widget/media_item.dart';

class MediaDisplaySection extends StatelessWidget {
  final bool hasVideo;
  final bool hasImage;
  final bool hasPdf;
  final bool isDark;
  final VoidCallback onShowVideo;
  final VoidCallback onShowImage;
  final Future<void> Function() onPickPdf;
  final Future<void> Function() onPickVideo;
  final Future<void> Function() onPickImage;

  const MediaDisplaySection({
    required this.onPickImage,
    required this.onPickVideo,
    required this.onPickPdf,
    required this.hasVideo,
    required this.hasImage,
    required this.hasPdf,
    required this.isDark,
    required this.onShowVideo,
    required this.onShowImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(!hasImage && !hasPdf && !hasVideo)
          Center(
                child: Text(
                  "No files uploaded yet",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              )
          else
          Column(
            children: [
              Text(
                "Uploaded before",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
          if (hasVideo)
            MediaItem(
              label: "Video File",
              icon: Icons.videocam,
              color: Colors.redAccent,
              show: onShowVideo,
              edit: onPickVideo ,
            ),
          if (hasImage)
            MediaItem(
              label: "Thumbnail Image",
              icon: Icons.image,
              color: Colors.blueAccent,
              show: onShowImage,
              edit: onPickImage,
            ),
          if (hasPdf)
            MediaItem(
              label: "PDF Document",
              icon: Icons.picture_as_pdf,
              color: Colors.orangeAccent,
              show: () {},
              edit: onPickPdf,
            ),
            ],
          ),
          
        ],
      ),
    );
  }
}
