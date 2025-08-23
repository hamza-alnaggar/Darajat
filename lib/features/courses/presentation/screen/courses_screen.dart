import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/course_card_big_2.dart';
import 'package:learning_management_system/core/widgets/home.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/courses_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/courses_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:learning_management_system/generated/l10n.dart'; // Import localization

class AllCoursesScreen extends StatefulWidget {
  const AllCoursesScreen({super.key, required this.type});

  final String type;

  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  
  String get _screenTitle {
    switch (widget.type) {
      case 'all':
        return S.of(context).all_courses;
      case 'free':
        return S.of(context).free_courses;
      case 'paid':
        return S.of(context).premium_courses;
      default:
        return S.of(context).courses;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialCourses();
    _scrollController.addListener(_onScroll);
  }

  void _loadInitialCourses() {
  final cubit = context.read<CoursesCubit>();
    switch (widget.type) {
      case 'all':
        cubit.getAllCourses();
        break;
      case 'free':
        cubit.getFreeCourses();
        break;
      case 'paid':
        cubit.getPaidCourses();
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreCourses();
    }
  }

  void _loadMoreCourses() {
    final cubit = context.read<CoursesCubit>();
    _isLoadingMore = true;
    
    switch (widget.type) {
      case 'all':
        cubit.loadMoreAllCourses();
        break;
      case 'free':
        cubit.loadMoreFreeCourses();
        break;
      case 'paid':
        cubit.loadMorePaidCourses();
        break;
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _screenTitle,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? CustomColors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? CustomColors.backgroundColor : CustomColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: isDark ? CustomColors.white : CustomColors.primary
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: isDark ? CustomColors.backgroundColor : CustomColors.white,
        child: BlocConsumer<CoursesCubit, CoursesState>(
          listener: (context, state) {
            
            if (state is AllCoursesSuccess ||
                state is FreeCoursesSuccess ||
                state is PaidCoursesSuccess ||
                state is AllCoursesFailure ||
                state is FreeCoursesFailure ||
                state is PaidCoursesFailure) {
              _isLoadingMore = false;
            }
          },
          builder: (context, state) {
            print(state);
            if (state is AllCoursesLoading ||
                state is FreeCoursesLoading ||
                state is PaidCoursesLoading) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: 280,
                    child: Skeletonizer(
                      enabled: true,
                      child: ListView.separated(
                        itemCount: 3, 
                        itemBuilder: (context, index) => courseLoading(),
                        separatorBuilder: (context, index) => SizedBox(width: 15.w),
                      ),
                    ),
                  ),
                ),
              );
            }

            // Error states
            if (state is AllCoursesFailure ) {
              return errorWidget(isDark, context, textTheme,state.errMessage);
            }
            if(state is FreeCoursesFailure )
                          return errorWidget(isDark, context, textTheme,state.errMessage);
            if(state is PaidCoursesFailure)
                          return errorWidget(isDark, context, textTheme,state.errMessage);

            // Empty states
            if (state is AllCoursesEmpty ||
                state is FreeCoursesEmpty ||
                state is PaidCoursesEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off, 
                      size: 72.r, 
                      color: isDark ? CustomColors.dark : CustomColors.primary
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      S.of(context).no_courses_available,
                      style: textTheme.headlineSmall?.copyWith(
                        color: isDark ? CustomColors.white  : Colors.black
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      S.of(context).check_back_later,
                      style: textTheme.bodyLarge?.copyWith(
                        color: isDark ? 
                          CustomColors.white.withOpacity(0.6) : 
                          Colors.black.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              );
            }

            List<CourseModel> courses = [];
            bool hasMore = false;

            if (widget.type == 'all') {
              if (state is AllCoursesSuccess) {
                courses = state.courses;
                hasMore = state.hasMore;
              } else if (state is AllCoursesLoadingMore) {
                courses = state.currentCourses;
                hasMore = true;
              }
            } 
            else if (widget.type == 'free') {
              if (state is FreeCoursesSuccess) {
                courses = state.courses;
                hasMore = state.hasMore;
              } else if (state is FreeCoursesLoadingMore) {
                courses = state.currentCourses;
                hasMore = true;
              }
            } 
            else if (widget.type == 'paid') {
              if (state is PaidCoursesSuccess) {
                courses = state.courses;
                hasMore = state.hasMore;
              } else if (state is PaidCoursesLoadingMore) {
                courses = state.currentCourses;
                hasMore = true;
              }
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Header section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Text(
                      S.of(context).browse_curated_collection,
                      style: textTheme.bodyLarge?.copyWith(
                        color: isDark ? 
                          CustomColors.white.withOpacity(0.7) : 
                            Colors.black
                      ),
                    ),
                  ),
                ),
                
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Center( 
                          child: SizedBox(
                            height: 350.h,
                            child: CourseCardBig2(
                              course: courses[index],
                              width: 280,
                            ),
                          ),
                        );
                      },
                      childCount: courses.length,
                    ),
                  ),
                ),
                
                if (hasMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: isDark ? CustomColors.dark : CustomColors.primary,
                        ),
                      ),
                    ),
                  ),
                
                // End of list message
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 40.h),
                    child: Center(
                      child: Text(
                        courses.isEmpty ? "" : S.of(context).end_of_list,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isDark ? 
                            CustomColors.white.withOpacity(0.5) : 
                            Colors.black
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Center errorWidget(bool isDark, BuildContext context, TextTheme textTheme,String text) {
    return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline, 
                    size: 64.r, 
                    color: isDark ? CustomColors.error : CustomColors.error
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    text,
                    style: textTheme.headlineSmall?.copyWith(
                      color: isDark ? CustomColors.error : CustomColors.error
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _loadInitialCourses,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? CustomColors.dark : CustomColors.primary,
                      foregroundColor: isDark ? CustomColors.white : CustomColors.textPrimary,
                    ),
                    child: Text(S.of(context).try_again),
                  ),
                ],
              ),
            );
  }
}