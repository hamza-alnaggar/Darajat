import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/widgets/CategoryDropdown.dart';
import 'package:learning_management_system/core/widgets/course_card_big_2.dart';
import 'package:learning_management_system/core/widgets/topic_selector.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_cubit.dart';

class CoursesByTopicScreen extends StatefulWidget {
  const CoursesByTopicScreen({super.key});

  @override
  State<CoursesByTopicScreen> createState() => _CoursesByTopicScreenState();
}

class _CoursesByTopicScreenState extends State<CoursesByTopicScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize categories
    context.read<CategoryCubit>().getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<GetCourseForTecherCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Courses by Topic'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Dropdown
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CategoryDropdown(
                onCategorySelected: (category) {
                  // Fetch topics when category is selected
                  context.read<TopicCubit>().getTopicsByCategory(category.id);
                },
              ),
            ),
            SizedBox(height: 8.h),
            
            // Topic Selector
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, categoryState) {
                if (categoryState is CategorySuccess || categoryState is ChangeData) {
                  return TopicSelector(
                    onTopicSelected: (topic) {
                      // Fetch courses when topic is selected
                      context.read<GetCourseForTecherCubit>().getCoursesByStatus(
                        'withArrangement',
                        topicId: topic.id,
                      );
                    },
                  );
                }
                return SizedBox();
              },
            ),
            SizedBox(height: 16.h),
            
            // Courses List
            Expanded(child: _buildCoursesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesList() {
    return BlocBuilder<GetCourseForTecherCubit, GetCourseForTecherState>(
      builder: (context, state) {
        if (state is CoursesByStatusLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CoursesByStatusFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'Failed to load courses',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.errMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      final topicId = context.read<TopicCubit>().selectedTopic?.id;
                      if (topicId != null) {
                        context.read<GetCourseForTecherCubit>().getCoursesByStatus(
                          'withArrangement',
                          topicId: topicId,
                        );
                      }
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is CoursesByStatusLoaded) {
          final courses = state.courses;
          
          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.collections_bookmark, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text(
                    'No courses found for this topic',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Try selecting a different topic or category',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: courses.length,
            separatorBuilder: (_, __) => SizedBox(height: 20.h),
            itemBuilder: (context, index) {
              final course = courses[index];
              return _buildCourseCard(course, index + 1);
            },
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'Select a category and topic to view courses',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCourseCard(CourseModel course, int rank) {
    return Stack(
      children: [
        CourseCardBig2(course: course, status: 'Rank #$rank',width: 280,),
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.people_alt, color: Colors.amber, size: 18.r),
                SizedBox(width: 4.w),
                Text(
                  '${course.numOfStudentsEnrolled}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

