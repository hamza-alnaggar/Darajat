// features/courses/presentation/screens/course_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episode_list_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_state.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/course_content_tab.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/over_view_tab.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';
import 'package:lottie/lottie.dart';

class CoursePage extends StatefulWidget {
  final int courseId;

  const CoursePage({
    super.key,
    required this.courseId,
  });

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  EpisodeModel? selectedEpisode;
  QuizModel? selectedQuiz;

  @override
  void initState() {
    super.initState();
    context.read<ShowCourseCubit>().showCourseForStudent(widget.courseId,);
    context.read<EpisodesListCubit>().getEpisodes(widget.courseId,false,true);
  }

  void _selectEpisode(EpisodeModel episode) {
  debugPrint('Selecting episode id=${episode.id}');

  final cubit = context.read<EpisodeDetailCubit>();
  cubit
    ..reset()
    ..getEpisode(episode.id)
    ..loadEpisodeMedia(episode.id, false, false);

  setState(() {
    selectedEpisode = episode;
    selectedQuiz = null;
  });
}
  void _selectQuiz(QuizModel quiz) {
    setState(() {
      selectedQuiz = quiz;
      selectedEpisode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShowCourseCubit, ShowCourseState>(
        builder: (context, courseState) {
          return BlocBuilder<EpisodesListCubit, EpisodesListState>(
            builder: (context, episodesState) {
              if (courseState is ShowCourseLoading ||
                  episodesState is EpisodesListLoading) {
                return Center(child: Lottie.asset("assets/images/loading.json"));
              }
      
              if (courseState is ShowCourseFailure) {
                return Center(
                  child: Text('Error: ${courseState.errMessage}'),
                );
              }
              if (episodesState is EpisodesListError) {
                return Center(child: Text('Error: ${episodesState.message}'));
              }
              if (courseState is ShowCourseSuccess &&
                  episodesState is EpisodesListLoaded) {
                return _buildCourseContent(
                  courseState.course,
                  episodesState.response.data,
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

 Widget _buildCourseContent(
  CourseDetailsModel course,
  List<EpisodeModel> episodes,
) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted &&
        selectedEpisode == null &&
        selectedQuiz == null &&
        episodes.isNotEmpty) {
      setState(() {
        selectedEpisode = episodes.first;
      });
    }
  });

  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
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
      iconTheme: IconThemeData(color: CustomColors.primary),
      backgroundColor: Colors.transparent, 
      foregroundColor: const Color(0xffF5F5F5),
      elevation: 0,
      centerTitle: true,
      leading: 
          IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: const Color(0xff29C3CD),
              onPressed: () => Navigator.of(context).pop(),
            )
        ,
        title: Text(course.title),
        bottom: const TabBar(
          dividerColor: CustomColors.primary2,
          labelColor:Colors.white,
          indicatorColor:CustomColors.primary2 ,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'Course content'),
            Tab(text: 'Overview'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              children: [
                CourseContentTab(
                  courseImage: course.imageUrl,
                  currentEpisode: selectedEpisode,
                  currentQuiz: selectedQuiz,
                  episodes: episodes,
                  onSelectEpisode: _selectEpisode,
                  onSelectQuiz: _selectQuiz,
                ),
                OverviewTab(course: course),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
