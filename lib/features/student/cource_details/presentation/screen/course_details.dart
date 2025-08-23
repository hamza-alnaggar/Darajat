import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_state.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/user_sub_model.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_state.dart';
import 'package:lottie/lottie.dart';

class CourseDetails extends StatefulWidget {
  CourseDetails({super.key});

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool _descExpanded = false;
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocBuilder<ShowCourseCubit, ShowCourseState>(
        builder: (context, state) {
        if(state is ShowCourseSuccess)
        { final course = state.course;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.h,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Image.network(
                        course.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Container(color: Colors.black54),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 75.h,
                        child: Column(
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50.r,
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              "Preview this course",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: theme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        course.description,
                        style: theme.titleSmall?.copyWith(
                          color: CustomColors.textSecondary,
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            course.rate.courseRating.toString(),
                            style: theme.bodyLarge,
                          ),
                          SizedBox(width: 4.w),
                          ...List.generate(
                            course.rate.courseRating,
                            (_) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '(532,345 ratings) ${course.numOfStudentsEnrolled} students',
                        style: theme.bodySmall,
                      ),
                      SizedBox(height: 15.h),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: "Created by ",
                              style: theme.bodyMedium,
                            ),
                            TextSpan(
                              text: course.teacher.fullName,
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.update,
                            size: 20.r,
                            color: CustomColors.textSecondary,
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            "publishing Date ${course.publishingDate}",
                            style: theme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            size: 20.r,
                            color: CustomColors.textSecondary,
                          ),
                          SizedBox(width: 7.w),
                          Text(course.language, style: theme.bodySmall),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      
                      SizedBox(height: 25.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "RUB ${course.price}  ",
                              style: theme.bodyLarge?.copyWith(fontSize: 20.sp),
                            ),
                            TextSpan(
                              text: "RUB 7,990,00",
                              style: theme.titleSmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: CustomColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: AppTextButton(
                          buttonText: "Buy now",
                          onpressed: () {},
                          borderRadius: 0,
                        ),
                      ),
                      SizedBox(height: 7.h),

                      SizedBox(height: 25.h),
                      Text(
                        "What you'll learn",
                        style: theme.headlineSmall?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: course.whatWillYouLearn.length,
                  (context, index) => WhatYouLearnWidget(
                    theme: theme,
                    text: course.whatWillYouLearn[index],
                    
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 30.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Curriculum",
                        style: theme.headlineSmall?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "${course.numOfEpisodes} Episodes - ${course.numOfHours} total length",
                        style: theme.titleSmall?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),// Add this above your curriculum SliverToBoxAdapter
              if(course.firstEpisodeMode!=null)
SliverToBoxAdapter(
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Start Learning",
          style: theme.headlineSmall?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        
        // First Episode Card
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CustomColors.primary2,
                CustomColors.primary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),)
            ],
          ),
          child: Stack(
            children: [
              // Background image with overlay
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(16.r),
              //   child: ColorFiltered(
              //     colorFilter: ColorFilter.mode(
              //       Colors.black.withOpacity(0.5),
              //       BlendMode.darken,
              //     ),
              //     child: Image.network(
              //       course.firstEpisodeMode!.imgaeUrl,
              //       width: double.infinity,
              //       height: 180.h,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              
              // Content
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: CustomColors.backgroundColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "Episode ${course.firstEpisodeMode!.episodeNumber}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      course.firstEpisodeMode!.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 10.h),
                    
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, 
                        color: Colors.white70, size: 16.sp),
                        SizedBox(width: 5.w),
                        Text(
                          course.firstEpisodeMode!.duration,
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                        SizedBox(width: 15.w),
                        Icon(Icons.visibility_outlined, 
                            color: Colors.white70, size: 16.sp),
                        SizedBox(width: 5.w),
                        Text(
                          "${course.firstEpisodeMode!.views} views",
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                        SizedBox(width: 15.w),
                        Icon(Icons.thumb_up_outlined, 
                            color: Colors.white70, size: 16.sp),
                        SizedBox(width: 5.w),
                        Text(
                          "${course.firstEpisodeMode!.likes} likes",
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Play episode
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.backgroundColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            icon: Icon(Icons.play_arrow),
                            label: Text("Play Now"),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        if (course.firstEpisodeMode!.isWatched)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: CustomColors.backgroundColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, 
                                    color: CustomColors.primary2, size: 16.sp),
                                SizedBox(width: 5.w),
                                Text("Watched", 
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                      ],
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
),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // “This course includes”
                      Text(
                        'This course includes',
                        style: theme.headlineSmall?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildIncludeRow(
                        Icons.ondemand_video,
                        '${course.numOfHours} total hours on-demand video',
                        theme,
                      ),
                      _buildIncludeRow(
                        Icons.article_outlined,
                        '15 Articles',
                        theme,
                      ),
                      
                      _buildIncludeRow(
                        Icons.favorite,
                        'Full lifetime access',
                        theme,
                      ),
                      _buildIncludeRow(
                        Icons.devices,
                        'Access on mobile, desktop',
                        theme,
                      ),
                      course.hasCertificate
                          ? _buildIncludeRow(
                            Icons.card_membership,
                            'Certificate of Completion',
                            theme,
                          )
                          : SizedBox.shrink(),
                      SizedBox(height: 30.h),

                      // “Requirements”
                      Text(
                        'Requirements',
                        style: theme.headlineSmall?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              color: CustomColors.textSecondary,
                              fontSize: 16.sp,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Access to a computer or phone with an internet connection.',
                              style: TextStyle(
                                color: CustomColors.textSecondary,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),

                      // “Description”
                      Text(
                        'Description',
                        style: theme.headlineSmall?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      AnimatedCrossFade(
                        firstChild: Text(
                          course.description.substring(0,50),
                          style: TextStyle(
                            color: CustomColors.textSecondary,
                            fontSize: 16.sp,
                          ),
                        ),
                        secondChild: Text(
                          course.description,
                          style: TextStyle(
                            color: CustomColors.textSecondary,
                            fontSize: 16.sp,
                          ),
                        ),
                        crossFadeState:
                            _descExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                      GestureDetector(
                        onTap:
                            () =>
                                setState(() => _descExpanded = !_descExpanded),
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            _descExpanded ? 'Show less' : 'Show more',
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          if(state is ProfileLoaded)
                          return InstructorCard(teacher: state.profile.user);
                          return SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "Student Feedback",
                        style: theme.headlineSmall?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            course.rate.courseRating.toString(),
                            style: theme.headlineLarge,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'course rating',
                            style: TextStyle(
                              color: CustomColors.textSecondary,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      for (int stars = 5; stars >= 1; stars--)
                        _buildRatingBar(
                          stars,
                          theme,
                          context,
                          course.rate,
                        ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          );}
          if(state is ShowCourseLoading){
            return Center(
              child: Lottie.asset('assets/images/loading.json'),
            );
          }
          return 
          SizedBox.shrink();
        },
      ),
    );
  }
}

class WhatYouLearnWidget extends StatelessWidget {
  const WhatYouLearnWidget({
    super.key,
    required this.theme,
    required this.text,
  });

  final TextTheme theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 20.r, color: CustomColors.textSecondary),
          SizedBox(width: 8.w),
          Expanded(child: Text(text, style: theme.titleSmall)),
        ],
      ),
    );
  }
}

class Section {
  final String title;
  final List<Lecture> lectures;
  bool isOpen = false;
  Section({required this.title, required this.lectures});
}

class Lecture {
  final String title;
  final String length;
  final bool isVideo;
  Lecture({required this.title, required this.length, required this.isVideo});
}

Widget _buildIncludeRow(IconData icon, String text, TextTheme theme) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      children: [
        Icon(icon, color: CustomColors.textSecondary, size: 22.r),
        SizedBox(width: 12.w),
        Expanded(child: Text(text, style: theme.titleSmall)),
      ],
    ),
  );
}

Widget _buildRatingBar(
  int starCount,
  TextTheme theme,
  BuildContext context,
  RateModel rateModel,
) {
  final Map<int, int> ratingsCount = {
    5: int.tryParse(rateModel.fiveStar) ?? 0,
    4: int.tryParse(rateModel.fourStar) ?? 0,
    3: int.tryParse(rateModel.threeStar) ?? 0,
    2: int.tryParse(rateModel.twoStar) ?? 0,
    1: int.tryParse(rateModel.oneStar) ?? 0,
  };
  final percent = ratingsCount[starCount] ?? 0;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.0.h),
    child: Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            if (index < starCount) {
              return Icon(Icons.star, color: Colors.amber, size: 16);
            } else {
              return Icon(
                Icons.star_border,
                color: CustomColors.textSecondary,
                size: 16,
              );
            }
          }),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 15.h,
                decoration: BoxDecoration(color: Colors.white10),
              ),
              FractionallySizedBox(
                widthFactor: percent / 100,
                child: Container(
                  height: 15.h,
                  decoration: BoxDecoration(color: CustomColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Text('$percent%', style: theme.bodyLarge),
      ],
    ),
  );
}



class InstructorCard extends StatelessWidget {
  const InstructorCard({super.key, required this.teacher});
  
  final UserSubModel teacher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
                            "Instructor",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15.h),
      Container(
        decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CustomColors.primary2,
                  CustomColors.primary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),)
              ],
            ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and avatar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with fallback to initials
                Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColors.backgroundColor
                  ),
                  child: teacher.profileImageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            teacher.profileImageUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            '${teacher.firstName[0]}${teacher.lastName.isNotEmpty ? teacher.lastName[0] : ''}',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.textPrimary
                            ),
                          ),
                        ),
                ),
                
                SizedBox(width: 16.w),
                
                // Name and title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${teacher.firstName} ${teacher.lastName}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.textPrimary,
                          fontSize: 18.sp,
                        ),
                      ),
                      
                      SizedBox(height: 4.h),
                      
                      if (teacher.jobTitle != null)
                        Text(
                          teacher.jobTitle.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: CustomColors.textPrimary,
                            fontSize: 14.sp,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
              if (teacher.country != null)
                _buildExpertiseChip(
                  icon: Icons.location_on,
                  text: teacher.country.toString(),
                ),
            
            SizedBox(height: 16.h),
            
            // Skills section
            if (teacher.skills != null && teacher.skills!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skills & Expertise',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: teacher.skills!
                        .take(4) // Limit to 4 skills
                        .map((skill) => Chip(
                              backgroundColor:CustomColors.backgroundColor,
                              label: Text(
                                skill.title,
                                style: TextStyle(
                                  color: CustomColors.textPrimary,
                                  fontSize: 12.sp,
                                ),
                              ),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                ],
              ),
            
            SizedBox(height: 30.h),
            
            // View Profile Button
            SizedBox(
              width: size.width,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(Routes.profileScreen,arguments: false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.backgroundColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'View Full Profile',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),]
    );
  }
  
  Widget _buildExpertiseChip({required IconData icon, required String text}) {
    return Chip(
      backgroundColor: CustomColors.backgroundColor,
      avatar: Icon(icon, size: 16.r, color: CustomColors.textPrimary),
      label: Text(
        text,
        style: TextStyle(fontSize: 12.sp, color:  CustomColors.textPrimary),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}