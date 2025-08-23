import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/teacher/widget/content_type_button.dart';

class ContentTypeSelector extends StatelessWidget {
  final bool isDark;
  final VoidCallback onVideoSelected;
  final VoidCallback onPdfSelected;
  final VoidCallback onClose;

  const ContentTypeSelector({
    required this.isDark,
    required this.onVideoSelected,
    required this.onPdfSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select content type",
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
                onPressed: onClose,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            "Select the main type of content. Additional files can be added as resources.",
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ContentTypeButton(
                icon: Icons.play_circle_outline,
                label: "Video",
                onPressed: onVideoSelected,
                isDark: isDark,
              ),
              ContentTypeButton(
                icon: Icons.picture_as_pdf_outlined,
                label: "PDF",
                onPressed: onPdfSelected,
                isDark: isDark,
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
