// features/courses/presentation/screens/course_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episode_list_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_state.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/course_content_tab.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/inline_video_player.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/over_view_tab.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

class CoursePage extends StatefulWidget {
  final int courseId;
  final bool isStudent;

  const CoursePage({
    super.key,
    required this.courseId,
    required this.isStudent,
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
    context.read<ShowCourseCubit>().showCourseForTeacher(widget.courseId,false);
    context.read<EpisodesListCubit>().getEpisodes(widget.courseId,false);
  }

  void _selectEpisode(EpisodeModel episode) {
      debugPrint('Selecting episode id=${episode.id}');

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<EpisodeDetailCubit, EpisodeDetailState>(
            listener: (context, state) {
              if (state is EpisodeDetailError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: BlocBuilder<ShowCourseCubit, ShowCourseState>(
          builder: (context, courseState) {
            return BlocBuilder<EpisodesListCubit, EpisodesListState>(
              builder: (context, episodesState) {
                if (courseState is ShowCourseLoading ||
                    episodesState is EpisodesListLoading) {
                  return const Center(child: CircularProgressIndicator());
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
        print('first episode');
        selectedEpisode = episodes.first;
      });
    }
  });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(course.title),
          bottom: const TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Course content'),
              Tab(text: 'Overview'),
            ],
          ),
        ),
        body: Column(
          children: [
            if (selectedEpisode != null)
              _buildVideoPreview(
                episode: selectedEpisode!,
                courseImage: course.imageUrl,
              )
            else if (selectedQuiz != null)
              _buildQuizPreview(selectedQuiz!, course.imageUrl),
            Expanded(
              child: TabBarView(
                children: [
                  CourseContentTab(
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

  Widget _buildVideoPreview({
    required EpisodeModel episode,
    required String courseImage,
  }) {
    final cubit = context.read<EpisodeDetailCubit>();
    if (cubit.episodeId != episode.id) {
          cubit
            ..reset()
            ..getEpisode(episode.id)
            ..loadEpisodeMedia(episode.id,false,false);
        }
    return InlineVideoPlayer(
        isCopy: false,
        episode: episode,
        isStudent: widget.isStudent,
        showExtraInfol: true,
    );
  }

  Widget _buildQuizPreview(QuizModel quiz, String courseImage) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.black.withOpacity(0.5)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.quiz_outlined, size: 40, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Quiz',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${quiz.numOfQuestions} Questions',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _startQuiz(context, quiz),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primary2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 10,
                  ),
                ),
                child: const Text('Start Quiz', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startQuiz(BuildContext context, QuizModel quiz) {
    context.pushNamed(Routes.startQuizScreen,arguments:quiz );
  }
}
