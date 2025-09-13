import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/categories_section.dart';
import 'package:learning_management_system/core/widgets/category_chips.dart';
import 'package:learning_management_system/core/widgets/course_card_big_2.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/courses_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/courses_state.dart';
import 'package:learning_management_system/features/courses/presentation/screen/courses_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:learning_management_system/generated/l10n.dart'; // أضف هذا الاستيراد

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   @override
  Size get preferredSize => const Size.fromHeight(1);

  @override
  void initState() {
    super.initState();
    context.read<CoursesCubit>().getAllCourses();
    context.read<CoursesCubit>().getFreeCourses();
    context.read<CoursesCubit>().getPaidCourses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CategoryCubit>(),
        ),
      ],
      child: Scaffold(
        appBar:  AppBar(

          leadingWidth: 75,
          flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
            Color(0xFF130830),
              Color(0xFF1b1344),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10,bottom: 10),
            child: Image.asset('assets/images/Darajat.png'),
          ),
          title: Text(S.of(context).app_name,style: theme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),),
        centerTitle: true,
        elevation: 10,
backgroundColor: Colors.transparent,
      foregroundColor: const Color(0xffF5F5F5),      ),
        body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric( vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildSectionHeader(
                    context: context,
                    title: S.of(context).free_courses, 
                    type: "free",
                    theme: theme,
                    isDark: isDark,
                  ),
                  SizedBox(height: 10.h),
                  _buildCoursesList(type: "free"),
                  
                  SizedBox(height: 20.h),
                  
                  // Paid Courses Section
                  _buildSectionHeader(
                    context: context,
                    title: S.of(context).paid_courses,
                    type: "paid",
                    theme: theme,
                    isDark: isDark,
                  ),
                  SizedBox(height: 10.h),
                  _buildCoursesList(type: "paid"),
                  
                  SizedBox(height: 30.h),
                  
                  const CategoriesSection(),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w),
                    child: const CategoryChips(),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // All Courses Section
                  _buildSectionHeader(
                    context: context,
                    title: S.of(context).all_courses, // استخدام الترجمة
                    type: "all",
                    theme: theme,
                    isDark: isDark,
                  ),
                  _buildCoursesList(type: "all"),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
    required String type,
    required TextTheme theme,
    required bool isDark,
  }) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title, 
            style: theme.headlineMedium?.copyWith(
              color: isDark ? CustomColors.white : Colors.black // تغيير لون النص حسب الوضع
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) => sl<CoursesCubit>(),
                  child: AllCoursesScreen(type: type),
                ),
              ),
            ),
            child: Text(
              S.of(context).see_all, // استخدام الترجمة
              style: theme.titleSmall?.copyWith(
                color: CustomColors.primary2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList({required String type}) {
     final theme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<CoursesCubit, CoursesState>(
      buildWhen: (previous, current) {
        switch (type) {
          case "free":
            return current is FreeCoursesLoading ||
                current is FreeCoursesSuccess ||
                current is FreeCoursesEmpty ||
                current is FreeCoursesFailure;
          case "paid":
            return current is PaidCoursesLoading ||
                current is PaidCoursesSuccess ||
                current is PaidCoursesEmpty ||
                current is PaidCoursesFailure;
          case "all":
            return current is AllCoursesLoading ||
                current is AllCoursesSuccess ||
                current is AllCoursesEmpty ||
                current is AllCoursesFailure;
          default:
            return false;
        }
      },
      builder: (context, state) {
        List<CourseModel> courses = [];
        bool isLoading = true;
        
        switch (type) {
          case "free":
            if (state is FreeCoursesSuccess ) {
              courses = state.courses;
              isLoading = false;
            }
            if(state is FreeCoursesEmpty){
              isLoading = false;
            }
            break;
          case "paid":
            if (state is PaidCoursesSuccess){
              courses = state.courses;
              isLoading = false;
            }
            if(state is PaidCoursesEmpty){
              isLoading = false;
            }
            break;
          case "all":
            if (state is AllCoursesSuccess) {
              courses = state.courses;
              isLoading = false;
            }
              if(state is AllCoursesEmpty){
              isLoading = false;
            }
            break;
        }

        if (isLoading && courses.isEmpty) {
          return Padding(
            padding:  EdgeInsets.only(left: 16.w),
            child: SizedBox(
              height: 372.h,
              child: Skeletonizer(
                enabled: true,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) =>courseLoading(),
                  separatorBuilder: (context, index) => SizedBox(width: 15.w),
                ),
              ),
            ),
          );
        }
        
        if (state is FreeCoursesFailure)
          return SizedBox(
            height: 280.h,
            child: Center(
              child: Text(
                state.errMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red, // استخدام لون الخطأ من الثيم
                ),
              ),
            ),
          );
        
        if(state is PaidCoursesFailure){
SizedBox(
            height: 280.h,
            child: Center(
              child: Text(
                state.errMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red, // استخدام لون الخطأ من الثيم
                ),
              ),
            ),
          );
        }
        if(state is AllCoursesFailure){
SizedBox(
            height: 280.h,
            child: Center(
              child: Text(
                state.errMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red, // استخدام لون الخطأ من الثيم
                ),
              ),
            ),
          );
        }
        
        return SizedBox(
          height: 372.h,
          child: courses.length == 0 ?
          Center(
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
                      style: theme.headlineSmall?.copyWith(
                        color: isDark ? CustomColors.white  : Colors.black
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      S.of(context).check_back_later,
                      style: theme.bodyLarge?.copyWith(
                        color: isDark ? 
                          CustomColors.white.withOpacity(0.6) : 
                          Colors.black.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              )
          : ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: (){
                context.pushNamed(Routes.courseDetailsScreen,arguments:{
                  'course':courses[index].id,
                  'profile':courses[index].teacherId
                });
              },
              child: CourseCardBig2(
                width: 250.w,
                course: courses[index],
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(width: 15.w),
          ),
        );
      },
    );
  }
}

class courseLoading extends StatelessWidget {
  const courseLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
                  width: 250.w,
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
  }
}
//    CarouselSlider.builder(
    //   options: CarouselOptions(
    //     height: 150.h,
    //     aspectRatio: 16 / 9,
    //     viewportFraction: 0.8,
    //     initialPage: 0,
    //     enableInfiniteScroll: true,
    //     autoPlay: true,
    //     autoPlayInterval: const Duration(seconds: 5),
    //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
    //     autoPlayCurve: Curves.fastOutSlowIn,
    //     enlargeCenterPage: true,
    //     enlargeFactor: 0.3,
    //     onPageChanged: (index, reason) {
    //       setState(() {
    //         _currentPage = index;
    //       });
    //     },
    //     scrollDirection: Axis.horizontal,
    //   ),
    //   itemCount: banner.length,
    //   itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
    //     return Container(
    //       margin: EdgeInsets.symmetric(horizontal: 5.0.w),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(12.r),
    //         color: CustomColors.primary2,
    //       ),
    //       child: CachedNetworkImage(
    //         imageUrl: banner[itemIndex],
    //         imageBuilder: (context, imageProvider) => Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(12.r),
    //             image: DecorationImage(
    //               image: imageProvider,
    //               fit: BoxFit.contain,
    //             ),
    //           ),
    //         ),
    //         placeholder: (context, url) => Shimmer.fromColors(
    //           baseColor: Colors.grey.shade300,
    //           highlightColor: Colors.grey.shade100,
    //           child: AspectRatio(
    //             aspectRatio: 16 / 9,
    //             child: Container(
    //               height: 150.h,
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(12.r),
    //                 color: Colors.grey.shade300,
    //               ),
    //             ),
    //           ),
    //         ),
    //         errorWidget: (context, url, error) => const Center(
    //           child: Icon(Icons.error, color: Colors.red),
    //         ),
    //         fit: BoxFit.cover,
    //       ),
    //     );
    //   },
    // ),