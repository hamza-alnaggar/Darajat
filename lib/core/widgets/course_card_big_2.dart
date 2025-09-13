import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';

class CourseCardBig2 extends StatelessWidget {
  const CourseCardBig2({
    super.key,
    required this.course,
    this.status,
    this.isFollowedCourse = false,
    required this.width,
  });

  final CourseModel course;
  final bool isFollowedCourse;
  final double width;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double progressFraction = _parsePercentageToFraction(course.percentageProgress);

    return GestureDetector(
      child: Container(
        width: width.w,
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: isDark ? CustomColors.secondary : CustomColors.secondary,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Stack(
                  children: [
                    Image.network(
                      //imageUrl:
                     // "http://192.168.1.7:8000/storage/uploads/courses/laravel_1.jpg",
                       course.imageUrl,
                      width: width.w,
                      height: 150.h,
                      fit: BoxFit.fill, 
                    //  placeholder: (context, url) => Container(color: Colors.grey[300]),
                     // errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    Container(
                      width: double.infinity,
                      height: 150.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: theme.headlineLarge?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? CustomColors.white : Colors.white,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Instructor and rating row
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: isDark ? CustomColors.black : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 16.r,
                          color: isDark ? CustomColors.textPrimary : CustomColors.primary2,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          course.teacher,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? CustomColors.white.withOpacity(0.8) : Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.amber[800]?.withOpacity(0.3)
                              : Colors.amber[800]?.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  course.rate.toString(),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[600],
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(Icons.star, color: Colors.amber[600], size: 16.r),
                              ],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "(${course.numOfStudentsEnrolled})",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark ? CustomColors.white.withOpacity(0.7) : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isDark ? CustomColors.black : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                        course.price == "0\$" ? "Free":course.price,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (status != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status!, isDark),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // SHOW PROGRESS WHEN THIS IS A FOLLOWED COURSE
                  if (isFollowedCourse)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // label row with percent text
                          Row(
                            children: [
                              Text(
                                progressFraction > 0
                                    ? '${(progressFraction * 100).toStringAsFixed(progressFraction * 100 % 1 == 0 ? 0 : 1)}% COMPLETE'
                                    : '0% COMPLETE',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? CustomColors.white.withOpacity(0.8) : Colors.grey.shade800,
                                ),
                              ),
                              const Spacer(),
                              // optional numeric display (66.6%)
                              if (course.percentageProgress != null)
                                Text(
                                  course.percentageProgress!.trim(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isDark ? CustomColors.white.withOpacity(0.7) : Colors.grey.shade600,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // custom progress bar
                          Container(
                            width: double.infinity,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: progressFraction.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [ // do not hardcode if you need themeable colours
                                        // default gradient if you want to adapt to theme you can change these
                                        Color(0xFF4CAF50),
                                        Color(0xFF2196F3),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.12),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Converts "66.6%" or "66.6" to 0.666. Robust to commas and missing % sign.
  double _parsePercentageToFraction(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 0.0;
    final match = RegExp(r'[\d\.,]+').firstMatch(raw);
    if (match == null) return 0.0;
    var numStr = match.group(0)!.replaceAll(',', '.');
    final val = double.tryParse(numStr) ?? 0.0;
    // if value seems like already a fraction (0.66) assume it's fraction, otherwise assume percent like 66.6
    if (val <= 1.0) return val;
    return (val / 100.0).clamp(0.0, 1.0);
  }

  Color _getStatusColor(String status, bool isDark) {
    switch (status.toLowerCase()) {
      case 'published':
        return isDark ? Colors.green[700]! : Colors.green;
      case 'pending':
        return isDark ? Colors.orange[700]! : Colors.orange;
      case 'rejected':
        return isDark ? Colors.red[700]! : Colors.red;
      case 'draft':
      default:
        return isDark ? Colors.grey[700]! : Colors.grey;
    }
  }
}
