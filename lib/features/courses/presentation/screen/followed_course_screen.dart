import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
import 'package:learning_management_system/core/widgets/course_card_big_2.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/followed_course_for_student_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/followed_courses_for_student_state.dart';
import 'package:lottie/lottie.dart';

class FollowedCoursesScreen extends StatelessWidget {
  const FollowedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Followed Courses'),
      body: BlocBuilder<FollowedCourseForStudentCubit, FollowedCoursesForStudentState>(
        builder: (context, state) {
          if (state is GetFollowedCoursesLoading) {
            return  Center(
              child: Lottie.asset('assets/images/loading.json'),
            );
          } else if (state is GetFollowedCoursesFailure) {
            return Center(
              child: Text(
                state.errMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is GetFollowedCoursesSuccess) {
            final courses = state.courses;
            if (courses.data.isEmpty) {
              return const Center(
                child: Text("You haven’t followed any courses yet."),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                itemCount: courses.data.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final course = courses.data[index];
                  return Center(
                    child: GestureDetector(
                      onTap: (){
                        context.pushNamed(Routes.episodesScreen);
                      },
                      child: CourseCardBig2(
                        course: course,
                        isFollowedCourse: true,
                        width:280,
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: Text("Press button to load courses."),
          );
        },
      ),
    );
  }
}
