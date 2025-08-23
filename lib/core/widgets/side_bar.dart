import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/course_card_big_2.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_state.dart';
import 'package:sidebarx/sidebarx.dart';

class TeacherCoursesScreen extends StatefulWidget {
  
  const TeacherCoursesScreen({super.key});

  @override
  State<TeacherCoursesScreen> createState() => _TeacherCoursesScreenState();
}

class _TeacherCoursesScreenState extends State<TeacherCoursesScreen> {
  final _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  final _pageController = PageController();
  final _statuses = ['approved', 'draft', 'pending', 'rejected'];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialCourses();
  }

  void _loadInitialCourses() {
    context.read<GetCourseForTecherCubit>().getCoursesByStatus(
          _statuses[_currentIndex],
        
        );
  }

  void _onStatusChanged(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    context.read<GetCourseForTecherCubit>().getCoursesByStatus(
          _statuses[index],
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSidebar(),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatusTabs(),
          Expanded(child: _buildCoursePages()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return SizedBox(
      width: 220,
      child: SidebarX(
      
        controller: _sidebarController,
        items: const [
          SidebarXItem(icon: Icons.dashboard, label: 'Dashboard'),
          SidebarXItem(icon: Icons.video_library, label: 'My Courses'),
          SidebarXItem(icon: Icons.analytics, label: 'Analytics'),
          SidebarXItem(icon: Icons.message, label: 'Messages'),
          SidebarXItem(icon: Icons.settings, label: 'Settings'),
        ],
        theme: SidebarXTheme(
          
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor),
          itemTextPadding: const EdgeInsets.only(left: 30),
          selectedItemTextPadding: const EdgeInsets.only(left: 30),
          itemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.transparent),
          ),
          selectedItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
              ],
            ),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            size: 24,
          ),
          selectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('My Courses', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
  
    );
  }

  Widget _buildStatusTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: CustomColors.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _statuses.length,
            (index) => GestureDetector(
              onTap: () => _onStatusChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statuses[index].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _currentIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoursePages() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) => _onStatusChanged(index),
      children: _statuses.map((status) {
        return BlocBuilder<GetCourseForTecherCubit, GetCourseForTecherState>(
          builder: (context, state) {
            if (state is CoursesByStatusLoading) {
              return _buildLoadingState();
            } else if (state is CoursesByStatusFailure) {
              return _buildErrorState(state.errMessage);
            } else if (state is CoursesByStatusLoaded) {
              return _buildCourseGrid(state.courses,state.status);
            }
            return _buildEmptyState();
          },
        );
      }).toList(),
    );
  }

  Widget _buildCourseGrid(List<CourseModel> courses, String status) {
  if (courses.isEmpty) return _buildEmptyState();
  return ListView.separated(
    itemCount: courses.length,
    separatorBuilder: (context, index) => SizedBox(height: 15.h),
    itemBuilder: (context, index) => Center(  
      child: SizedBox( 
        width: 300.w,
        child: GestureDetector(
          onTap: (){
            context.pushNamed(Routes.createCourseScreen,arguments:{
                'courseId':courses[index].id,
                'status':status,
                'isCopy':status == 'pending'|| status == 'rejected'
            } );
          },
          child: CourseCardBig2(
            course: courses[index],
            status: status,
            width: 300.w,  
          ),
        ),
      ),
    ),
  );
}
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text('Loading courses...',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, 
              size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 20),
          Text('Error loading courses',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadInitialCourses,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_bookmark_outlined,
              size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 20),
          Text('No courses available',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text('Create your first course to get started',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Create Course'),
          ),
        ],
      ),
    );
  }
}

