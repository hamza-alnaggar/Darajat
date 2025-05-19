import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';


class CourseCardSmall extends StatelessWidget {
  const CourseCardSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: CustomColors.darkGrey
        ),
        borderRadius: BorderRadius.circular(10.r)
      ),
      width: 180.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              'assets/images/course.jpg',
              width:180.w ,
              height: 110.h,
              fit: BoxFit.cover,
              )
          ),
          SizedBox(height: 5.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 3,
                  'The Complete Python\nBootcamp From Zero to Hero',
                  style:theme.titleLarge?.copyWith(
                    overflow: TextOverflow.ellipsis,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Jose Portilla, Pierian Training',
                  style: theme.labelMedium
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      '4.6',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.star, color: Colors.amber[600], size: 15.r),
                    Icon(Icons.star, color: Colors.amber[600], size: 15.r),
                    Icon(Icons.star, color: Colors.amber[600], size: 15.r),
                    Icon(Icons.star, color: Colors.amber[600], size: 15.r),
                    Icon(Icons.star, color: Colors.amber[600], size: 15.r),
                    Text("(534,995)",style: theme.labelMedium)
                  ],
                ),
                SizedBox(height: 6.h,),
                Text("100.0 \$",style:theme.headlineSmall)
              ],
            ),
          ),
        ],
      ),
    );
  }
}