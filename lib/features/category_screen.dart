import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
import 'package:learning_management_system/core/widgets/course_card_big_2.dart';
import 'package:learning_management_system/core/widgets/home.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_search_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_state.dart';
import 'package:learning_management_system/generated/l10n.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).categories,
        showBackButton: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    S.of(context).all_categories,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            sliver: SliverToBoxAdapter(
              child: _buildCategoryChips(context),
            ),
          ),
          
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            sliver: SliverToBoxAdapter(
              child: Text(
                _selectedCategoryId == null 
                  ? S.of(context).all_courses
                  : S.of(context).category_courses,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          
          _buildResultsSection(),
          
          SliverToBoxAdapter(
            child: SizedBox(height: 30.h),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return SizedBox(
            height: 70.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Container(
                    width: 100.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              },
            ),
          );
        }
        
        if (state is CategoryFailure) {
          return Text('Error: ${state.errMessage}');
        }
        
        if (state is CategorySuccess) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: FilterChip(
                    label: Text(
                      S.of(context).see_all,
                      style: TextStyle(
                        color: _selectedCategoryId == null 
                          ? Colors.white 
                          : isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: _selectedCategoryId == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryId = null;
                      });
                    },
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    selectedColor: CustomColors.primary2,
                    checkmarkColor: Colors.white,
                  ),
                ),
                
                // Category chips
                ...state.categories.map((category) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: FilterChip(
                      label: Text(
                        category.title,
                        style: TextStyle(
                          color: _selectedCategoryId == category.id.toString()
                            ? Colors.white 
                            : isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      avatar: CircleAvatar(
                        backgroundImage: NetworkImage(category.imageUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      selected: _selectedCategoryId == category.id.toString(),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryId = category.id.toString();
                        });
                        context.read<CourseSearchCubit>().getCoursesByCategory(category.id.toString());
                      },
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      selectedColor: CustomColors.primary2,
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }
        
        return Container();
      },
    );
  }

  Widget _buildResultsSection() {
    return BlocBuilder<CourseSearchCubit, CourseSearchState>(
      builder: (context, state) {
        if (state is CourseSearchInitial) {
          // Initially load all courses
          return _buildLoadingGrid();
        }
        
        if (state is CourseSearchLoading) {
          return _buildLoadingGrid();
        }
        
        if (state is CourseSearchEmpty) {
          return _buildEmptyState();
        }
        
        if (state is CourseSearchFailure) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Center(
                child: Text(
                  'Error: ${state.errMessage}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          );
        }
        
        if (state is CourseSearchSuccess) {
          return _buildCourseList(state.courses);
        }
        
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }

  Widget _buildLoadingGrid() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: courseLoading(),
              ),
            );
          },
          childCount: 3,
        ),
      ),
    );
  }

  Widget _buildCourseList(List<CourseModel> courses) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Center(
              child: SizedBox(
                height: 380.h,
                width: 280,
                child: GestureDetector(
                  child: CourseCardBig2(course: courses[index], width: 280),
                  onTap: () {
                    context.pushNamed(Routes.courseDetailsScreen, arguments: {
                      'course': courses[index].id,
                      'profile': courses[index].teacherId
                    });
                  },
                ),
              ),
            ),
          ),
          childCount: courses.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                size: 100.r,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              SizedBox(height: 20.h),
              Text(
                _selectedCategoryId == null
                  ? S.of(context).no_courses_available
                  : S.of(context).no_courses_in_category,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                S.of(context).check_other_categories,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}