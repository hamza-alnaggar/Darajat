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
    required this.width,
  });

  final CourseModel course;
  final double width;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      child: Container(
        width: width.w,
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: isDark ? CustomColors.secondary : CustomColors.secondary,
          boxShadow: [
            BoxShadow(
              color: isDark 
                ? Colors.black.withOpacity(0.4) 
                : Colors.black.withOpacity(0.1),
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
                    CachedNetworkImage(
                        imageUrl: course.imageUrl,
                        width: width.w,
                        height: 150.h,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                          color: isDark 
                            ? CustomColors.black 
                            : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline, 
                          size: 16.r, 
                          color: isDark 
                            ? CustomColors.textPrimary 
                            : CustomColors.primary2
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          course.teacher,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark 
                              ? CustomColors.white.withOpacity(0.8) 
                              : Colors.grey.shade700,
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
                                Icon(
                                  Icons.star, 
                                  color: Colors.amber[600], 
                                  size: 16.r
                                ),
                              ],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "(${course.numOfStudentsEnrolled})",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark 
                                  ? CustomColors.white.withOpacity(0.7) 
                                  : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isDark
                            ? CustomColors.textPrimary.withOpacity(0.8)
                            : CustomColors.primary2.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          course.price,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? CustomColors.textSecondary : Colors.white,
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
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
    );
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

// SizedBox(height = 16.h),
                  
//                   // Bottom info row
//                   Row(
//                     children = [
//                       Price tag
                      
                      
//                      Spacer(),
                      
//                       Progress bar
//                       Expanded(
//                         flex: 2,
//                         child:  Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "87% COMPLETE",
//                                       style: TextStyle(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.bold,
//                                         color: isDark ? Colors.white70 : Colors.grey.shade600,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8.h),
//                                     Container(
//                                       width: 120.w,
//                                       height: 8.h,
//                                       decoration: BoxDecoration(
//                                         color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
//                                         borderRadius: BorderRadius.circular(4.r),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black.withOpacity(0.1),
//                                             blurRadius: 2,
//                                             offset: Offset(0, 1),
//                                           )
//                                         ],
//                                       ),
//                                       child: Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Container(
//                                           width: 100.w,
//                                           decoration: BoxDecoration(
//                                             gradient: LinearGradient(
//                                               colors: [
//                                                 CustomColors.primary2,
//                                                 Colors.lightBlueAccent,
//                                               ],
//                                             ),
//                                             borderRadius: BorderRadius.circular(4.r),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: CustomColors.primary2.withOpacity(0.4),
//                                                 blurRadius: 6,
//                                                 spreadRadius: 1,
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                       ),