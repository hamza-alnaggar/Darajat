import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/course_card_big_2.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_state.dart';
import 'package:lottie/lottie.dart';

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
    final categoryCubit = context.read<CategoryCubit>();
    final topicCubit = context.read<TopicCubit>();

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
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child:BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CategoryModel>(
              isExpanded: true,
              value: categoryCubit.selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: CustomColors.primary2.withOpacity(0.3),
                  ),
                ),
                prefixIcon: Icon(Icons.category, color: CustomColors.primary2),
              ),
              items: categoryCubit.categoryList.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.title),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                categoryCubit.selectCategory(value);
                context.read<TopicCubit>().resetTopic();
                context.read<TopicCubit>().getTopicsByCategory(value.id);
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
              hint: const Text('Select course category'),
            ),
          ],
        );
      },
    ),
            ),
            SizedBox(height: 8.h),
            
            BlocBuilder<TopicCubit, TopicState>(
              builder: (context, state) {
              if (state is TopicLoading) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.primary2),
          );
        }
                if (state is TopicSuccess || state is ChangeTopic) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Course Topic', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<TopicModel>(
                              value: topicCubit.selectedTopic,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: CustomColors.primary2.withOpacity(0.3),
                                  ),
                                ),
                                prefixIcon: Icon(Icons.language, color: CustomColors.primary2),
                              ),
                              items: topicCubit.topicList.map((topic) {
                                return DropdownMenuItem(value: topic, child: Text(topic.title));
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) 
                                return;
                                topicCubit.selectTopic(value);
                                context.read<GetCourseForTecherCubit>().getCoursesByStatus(
                          'withArrangement',
                          topicId: value.id,
                        );
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a topic';
                                }
                                return null;
                              },
                              hint: const Text('Select course topic'),
                            ),
                          ],
                        ),
                  );
                }
                return SizedBox();
              },
            ),
            SizedBox(height: 16.h),
            
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
        return Center(child: Lottie.asset('assets/images/loading.json'));
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

       
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                            courses.length * 2 - 1,
                            (i) {
                              if (i.isOdd) return SizedBox(height: 20.h);
                              final index = i ~/ 2;
                              final course = courses[index];
                              return Center(child: _buildCourseCard(course, index + 1));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
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

