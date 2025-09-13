import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_state.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/inline_video_player.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/helper/extention.dart';

class CourseContentTab extends StatefulWidget {
  final List<EpisodeModel> episodes;
  EpisodeModel? currentEpisode;
  final QuizModel? currentQuiz;
  final Function(EpisodeModel) onSelectEpisode;
  final Function(QuizModel) onSelectQuiz;
  final String courseImage;

  CourseContentTab({
    super.key,
    required this.episodes,
    required this.onSelectEpisode,
    required this.onSelectQuiz,
    required this.currentEpisode,
    required this.currentQuiz,
    required this.courseImage,
  });

  @override
  State<CourseContentTab> createState() => _CourseContentTabState();
}

class _CourseContentTabState extends State<CourseContentTab> {
  bool _isLiking = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EpisodeDetailCubit, EpisodeDetailState>(
      listener: (context, state) {
        if (state is EpisodeDetailLoaded) {
          setState(() {
            widget.currentEpisode = state.episode.episodeModel;
          });

          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success !',
              message: state.episode.message,
              contentType: ContentType.success,
              color: Colors.green,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }

        if (state is EpisodeDetailDownloadSuccess) {
          final path = state.savedPath;

          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success !',
              message: 'File downloaded to $path',
              contentType: ContentType.success,
              color: Colors.green,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Builder(
              builder: (context) {
                if (widget.currentEpisode != null) {
                  return InlineVideoPlayer(
                    episode: widget.currentEpisode!,
                    isStudent: true,
                    isCopy: false,
                  );
                } else if (widget.currentQuiz != null) {
                  return _buildQuizPreview(widget.currentQuiz!, context);
                } else {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.video_library,
                            color: Colors.white54,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select an episode or quiz',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          if (widget.currentEpisode != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(
                    icon: Icons.remove_red_eye_outlined,
                    value: _formatNumber(widget.currentEpisode!.views),
                    label: 'المشاهدات',
                  ),
                  _buildLikeButton(context, widget.currentEpisode!),
                  _buildStatItem(
                    icon: Icons.timer_outlined,
                    value: widget.currentEpisode!.duration,
                    label: 'المدة',
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: widget.episodes.length,
              itemBuilder: (context, index) {
                final episode = widget.episodes[index];
                return Column(
                  children: [
                    // Only show episode item. Quiz is now accessed via an icon inside the episode row.
                    ContentItem.episode(
                      onDownload: () {
                        context.read<EpisodeDetailCubit>().downloadFile(episode.id);
                      },
                      episode: episode,
                      onTap: () => widget.onSelectEpisode(episode),
                      onQuizTap: (episode.quiz != null && episode.quiz!.numOfQuestions > 0)
                          ? () => widget.onSelectQuiz(episode.quiz!)
                          : null,
                    ),
                    SizedBox(height: 30.h),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPreview(QuizModel quiz, BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Icon(Icons.quiz_outlined, size: 40, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            'Quiz',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${quiz.numOfQuestions} Questions',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => _startQuiz(context, quiz),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primary2,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            ),
            child: const Text('Start Quiz', style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _startQuiz(BuildContext context, QuizModel quiz) {
    context.pushNamed(Routes.startQuizScreen, arguments: quiz);
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLikeButton(BuildContext context, EpisodeModel currentEpisode) {
    return GestureDetector(
      onTap: () async {
        if (widget.currentEpisode == null) return;
        if (_isLiking) return;

        setState(() {
          _isLiking = true;
          final currentlyLiked = widget.currentEpisode!.isLiked ?? false;
          widget.currentEpisode = widget.currentEpisode!.copyWith(
            isLiked: !currentlyLiked,
            likes: currentlyLiked
                ? widget.currentEpisode!.likes - 1
                : widget.currentEpisode!.likes + 1,
          );
        });

        final cubit = context.read<EpisodeDetailCubit>();
        final success = await cubit.toggleLike(widget.currentEpisode!.id);

        if (!success) {
          setState(() {
            final revertedLiked = widget.currentEpisode!.isLiked ?? false;
            widget.currentEpisode = widget.currentEpisode!.copyWith(
              isLiked: !revertedLiked,
              likes: revertedLiked
                  ? widget.currentEpisode!.likes - 1
                  : widget.currentEpisode!.likes + 1,
            );
          });
        }

        if (mounted) {
          setState(() => _isLiking = false);
        }
      },
      child: Row(
        children: [
          _isLiking
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  (widget.currentEpisode?.isLiked ?? false)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 16,
                  color: (widget.currentEpisode?.isLiked ?? false)
                      ? Colors.red
                      : Colors.white70,
                ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatNumber(widget.currentEpisode?.likes ?? 0),
                style: const TextStyle(color: Colors.white),
              ),
              const Text(
                'الإعجابات',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class ContentItem extends StatefulWidget {
  final EpisodeModel? episode;
  final QuizModel? quiz;
  final VoidCallback onTap;
  final bool? isQuizedCompleted;
  final void Function()? onDownload;

  // NEW: add onQuizTap callback so the quiz can be launched from inside the episode row
  final VoidCallback? onQuizTap;

  const ContentItem.episode({
    super.key,
    required this.episode,
    required this.onTap,
    this.isQuizedCompleted = false,
    this.onDownload,
    this.onQuizTap,
  }) : quiz = null;

  // keep quiz constructor for backwards compatibility but it's not used now
  const ContentItem.quiz({
    super.key,
    required this.quiz,
    this.onDownload,
    this.isQuizedCompleted,
    required this.onTap,
  }) : episode = null, onQuizTap = null;

  @override
  State<ContentItem> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.episode != null) {
      return _buildEpisodeItem(widget.episode!, context);
    } else if (widget.quiz != null) {
      return _buildQuizItem(widget.quiz!, completed: widget.isQuizedCompleted ?? false);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildEpisodeItem(EpisodeModel episode, BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: CustomColors.primary2.withOpacity(0.1),
                  child: Icon(Icons.play_circle_outline, color: episode.isWatched! ? CustomColors.primary2 : Colors.grey),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Text(
                    'Episode ${episode.episodeNumber}: ${episode.title}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pushNamed(Routes.commentScreen, arguments: episode.id);
                  },
                  child: const Icon(Icons.comment_outlined, color: Colors.white),
                ),
                SizedBox(width: 8.w),

                // QUIZ ICON: shown inline like comment and download
                if (episode.quiz != null && (episode.quiz!.numOfQuestions ?? 0) > 0)
                  GestureDetector(
                    onTap: widget.onQuizTap != null
                        ? () {
                            if (episode.isQuizCompleted ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Quiz already completed')),
                              );
                              return;
                            }
                            widget.onQuizTap!();
                          }
                        : null,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          size: 25,
                          Icons.quiz_outlined,
                          color:  Colors.amber 
                        ),
                        if (episode.isQuizCompleted ?? false)
                          Positioned(bottom: -7,right: -14,child: const Icon(Icons.check_circle_outline ,color:Colors.amber,size: 18,)),
                      ],
                    ),
                  ),
                episode.isQuizCompleted == true
                    ? SizedBox(width: 20,)
                    : SizedBox(width: episode.quiz != null ? 8.w : 0), 

                GestureDetector(
                  onTap: _isDownloading
                      ? null
                      : () async {
                          setState(() => _isDownloading = true);
                          try {
                            await context.read<EpisodeDetailCubit>().downloadFile(episode.id);
                          } catch (e) {
                            // ignore
                          } finally {
                            if (mounted) setState(() => _isDownloading = false);
                          }
                        },
                  child: _isDownloading
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.picture_as_pdf, color: Colors.red),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizItem(QuizModel quiz, {bool completed = false}) {
    return ListTile(
      onTap: completed
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Quiz already completed'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          : widget.onTap,
      leading: const Icon(Icons.quiz_outlined, color: CustomColors.primary),
      title: const Text('Quiz'),
      subtitle: Text('${quiz.numOfQuestions} questions'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (completed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
