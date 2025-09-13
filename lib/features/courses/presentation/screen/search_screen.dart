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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

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
      appBar:  CustomAppBar(
    title: S.of(context).discover_courses,
    showBackButton: true,
  ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverToBoxAdapter(
              child: _buildSearchBar(context),
            ),
          ),
          
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                S.of(context).search_results,
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

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: isDark
            ? LinearGradient(
                colors: [Color(0xFF1b1344), Color(0xFF130830)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            )
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontSize: 16.sp,
          color: isDark ? Color(0xffF5F5F5) : Color(0xFF1b1344),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? null : Colors.white,
          hintText: S.of(context).search_courses_hint, // Localized
          hintStyle: TextStyle(
            color: isDark ? Color(0xFF655c7a) : Color(0xFF655c7a).withOpacity(0.7),
            fontSize: 15.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Color(0xff29C3CD) : Color(0xFFD27DF4),
            size: 24.r,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(
              color: Color(0xff29C3CD).withOpacity(0.4),
              width: 1.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded,
                      color: isDark ? Color(0xff29C3CD) : Color(0xFFD27DF4)),
                  onPressed: () {
                    _searchController.clear();
                    context.read<CourseSearchCubit>().searchCourses('');
                  },
                )
              : null,
        ),
        cursorColor: Color(0xff29C3CD),
        onChanged: (value) {
          context.read<CourseSearchCubit>().searchCourses(value);
        },
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
          return  SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: state.categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ActionChip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(category.imageUrl),
                    ),
                    label: Text(category.title),
                    onPressed: () {
                      context.read<CourseSearchCubit>().getCoursesByCategory(category.id.toString());
                    },
                  ),
                );
              }).toList(),
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
          return _buildEmptyState();
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
            child: SizedBox(
              height: 370.h,
              width: 280,
              child: GestureDetector(
                child: Center(child: CourseCardBig2(course: courses[index],width: 280,)),
                onTap: () {
                  context.pushNamed(Routes.courseDetailsScreen, arguments: {
                    'course': courses[index].id,
                    'profile': courses[index].teacherId
                  });
                },
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
                Icons.search_off,
                size: 100.r,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              SizedBox(height: 20.h),
              Text(
                S.of(context).no_courses_found, // Localized
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                S.of(context).try_different_keywords, // Localized
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: theme.hintColor,
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  context.read<CourseSearchCubit>().searchCourses('');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primary2,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  S.of(context).clear_search, // Localized
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}