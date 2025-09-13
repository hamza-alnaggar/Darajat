import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/course_card_big_2.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_state.dart';
import 'package:learning_management_system/features/student/home/presentation/screen/entry_point.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:learning_management_system/generated/l10n.dart';

class TeacherCoursesScreen extends StatefulWidget {
  const TeacherCoursesScreen({super.key});

  @override
  State<TeacherCoursesScreen> createState() => _TeacherCoursesScreenState();
}

class _TeacherCoursesScreenState extends State<TeacherCoursesScreen> 
    with SingleTickerProviderStateMixin {
  final _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  final _statuses = ['approved', 'draft', 'pending', 'rejected', 'deleted'];
  
  late TabController _tabController;
  final Map<String, bool> _loadedTabs = {};
  final Map<String, List<CourseModel>> _cachedCourses = {};

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(
      length: _statuses.length,
      vsync: this,
      initialIndex: 0,
    );
    
    // Initialize cache and loaded states
    for (var status in _statuses) {
      _loadedTabs[status] = false;
      _cachedCourses[status] = [];
    }
    
    // Load initial courses
    _loadInitialCourses();

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      
      final status = _statuses[_tabController.index];
      if (!_loadedTabs[status]!) {
        context.read<GetCourseForTecherCubit>().getCoursesByStatus(status);
      }
    });

    // Keep UI consistent when sidebar controller changes
    _sidebarController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadInitialCourses() {
    final currentStatus = _statuses[_tabController.index];
    if (!_loadedTabs[currentStatus]!) {
      context.read<GetCourseForTecherCubit>().getCoursesByStatus(currentStatus);
    }
  }

  Future<void> _refreshTab(String status) async {
    context.read<GetCourseForTecherCubit>().getCoursesByStatus(status);
  }
   Widget _buildDrawer() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [CustomColors.secondary.withOpacity(0.06), Colors.transparent]
                : [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
                    Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  children: [
                    DrawerItem(
                      icon: Icons.computer,
                      title: 'Crate Course',
                      subtitle: 'Go to create course',
                      onTap: () => context.pushNamed(Routes.createCourseScreen),
                    ),
                    DrawerItem(
                      icon: Icons.person,
                      title: 'profile',
                      subtitle: 'Show your Profile',
                      onTap: () => context.pushNamed(Routes.profileScreen,arguments: {
                        "isUser":true,
                      "isTeacherView":true
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'v1.0.0',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    drawer: _buildDrawer(),
    appBar: _buildAppBar(context),
    body: TabBarView(
      controller: _tabController,
      children: _statuses.map((status) {
        return _buildTabContent(status);
      }).toList(),
    ),
  );
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
    title: Text(S.of(context).my_courses),
    backgroundColor: CustomColors.secondary,
    iconTheme: Theme.of(context).iconTheme,
    bottom: TabBar(
      controller: _tabController,
      isScrollable: true,
      padding: EdgeInsets.zero,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Theme.of(context).colorScheme.primary,
      unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
      tabs: _statuses.map((status) {
        return Tab(
          text: status.toUpperCase(),
        );
      }).toList(),
    ),
  );
}

  Widget _buildTabContent(String status) {
    return BlocConsumer<GetCourseForTecherCubit, GetCourseForTecherState>(
      listener: (context, state) {
        if (state is CoursesByStatusLoaded && state.status == status) {
          _cachedCourses[status] = state.courses;
          _loadedTabs[status] = true;
        }
      },
      builder: (context, state) {
        final courses = _cachedCourses[status] ?? [];

        if (state is CoursesByStatusLoading && courses.isEmpty) {
          return _buildLoadingState();
        } else if (state is CoursesByStatusFailure && courses.isEmpty) {
          return _buildErrorState(state.errMessage);
        } else if (state is CoursesByStatusLoaded || courses.isNotEmpty) {
          return _buildCourseGridWithRefresh(courses, status);
        }
        return _buildEmptyState();
      },
    );
  }

  Widget _buildCourseGridWithRefresh(List<CourseModel> courses, String status) {
    return RefreshIndicator(
      onRefresh: () => _refreshTab(status),
      child: _buildCourseGrid(courses, status),
    );
  }

  Widget _buildCourseGrid(List<CourseModel> courses, String status) {
    if (courses.isEmpty) return _buildEmptyState();
    
    return ListView.separated(
      itemCount: courses.length,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      separatorBuilder: (context, index) => SizedBox(height: 15.h),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          context.pushNamed(Routes.createCourseScreen, arguments: {
            'courseId': courses[index].id,
            'status': status,
            'isCopy': status == 'pending' || status == 'rejected'
          });
        },
        child: Center(
          child: CourseCardBig2(
            width:280 ,
            course: courses[index],
            status: status,
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
          Text(S.of(context).loading_courses, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 20),
          Text(S.of(context).error_loading_courses, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadInitialCourses,
            child: Text(S.of(context).retry),
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
          Text(S.of(context).no_courses_available, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(S.of(context).create_first_course, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              context.pushNamed(Routes.createCourseScreen);
            },
            icon: const Icon(Icons.add),
            label: Text(S.of(context).create_course),
          ),
        ],
      ),
    );
  }
}