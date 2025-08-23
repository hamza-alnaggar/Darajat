  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:learning_management_system/core/theming/colors.dart';
  import 'package:learning_management_system/core/widgets/category_chips.dart';
  import 'package:learning_management_system/core/widgets/course_card_big_2.dart' hide SizedBox, Row;
  import 'package:learning_management_system/features/courses/presentation/cubit/course_search_cubit.dart';
  import 'package:learning_management_system/features/courses/presentation/cubit/topic_cubit.dart';
  import 'package:learning_management_system/features/courses/presentation/cubit/topic_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

  class CoursesByCategoryOrTopicScreen extends StatelessWidget {
    const CoursesByCategoryOrTopicScreen({super.key});

    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Browse Courses',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.r),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomScrollView(
            slivers: [
              // Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
                  child: Text(
                    'Filter by Topic',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              
              // Topic Chips
              SliverToBoxAdapter(
                child: BlocBuilder<TopicCubit, TopicState>(
                  builder: (context, state) {
                    if (state is TopicSuccess) {
                      return ChipsTopicWidget(ctx: context, topics: state.topics);
                    } else if (state is TopicLoading) {
                      return _buildTopicLoading();
                    } else if (state is TopicFailure) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Text(
                          'Failed to load topics: ${state.errMessage}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              
              SliverToBoxAdapter(
                child: SizedBox(height: 24.h),
              ),
              
              // Course count text
              SliverToBoxAdapter(
                child: BlocBuilder<CourseSearchCubit, CourseSearchState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Text(
                        state is CourseSearchSuccess 
                          ? '${state.courses.length} Courses Found'
                          : 'Available Courses',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Course List
              BlocBuilder<CourseSearchCubit, CourseSearchState>(
                builder: (context, state) {
                  if (state is CourseSearchSuccess) {
                    return _buildCourseList(state.courses);
                  } else if (state is CourseSearchLoading) {
                    return _buildCourseLoading();
                  } else if (state is CourseSearchFailure) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Error: ${state.errMessage}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  } else if (state is CourseSearchEmpty) {
                    return SliverToBoxAdapter(
                      child: _buildEmptyState(context),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: _buildInitialState(context),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildTopicLoading() {
      return Skeletonizer(  // Skeleton for loading state
            enabled: true,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(5, (index) => Chip(
                label: const Text('Loading category'),
                avatar: CircleAvatar(backgroundColor: Colors.transparent),
              )),
            ),);
    }

    Widget _buildCourseList(List<dynamic> courses) {
      return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Center( 
            child: CourseCardBig2(
              course: courses[index],
              width: 280.w, 
            ),
          );
        },
        childCount: courses.length,
      ),
    ),
  );
    }

    Widget _buildCourseLoading() {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              width: 280.w,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 16.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Container(
                              width: 32.r,
                              height: 32.r,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              height: 16.h,
                              width: 120.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: 4,
        ),
      );
    }

    Widget _buildEmptyState(BuildContext context){
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80.r,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            SizedBox(height: 20.h),
            Text(
              'No courses found',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Try selecting a different topic',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildInitialState(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category,
              size: 60.r,
              color: CustomColors.primary2,
            ),
            SizedBox(height: 20.h),
            Text(
              'Select a topic to view courses',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      );
    }
  }