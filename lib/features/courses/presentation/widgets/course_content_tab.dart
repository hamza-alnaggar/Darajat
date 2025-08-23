// features/courses/presentation/widgets/course_content_tab.dart
import 'package:flutter/material.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

class CourseContentTab extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final Function(EpisodeModel) onSelectEpisode;
  final Function(QuizModel) onSelectQuiz;

  const CourseContentTab({
    super.key,
    required this.episodes,
    required this.onSelectEpisode,
    required this.onSelectQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return Column(
          children: [
            ContentItem.episode(
              episode: episode,
              onTap: () => onSelectEpisode(episode),
            ),
            if (episode.quiz != null && episode.quiz!.numOfQuestions > 0)
              ContentItem.quiz(
                quiz: episode.quiz!,
                onTap: () => onSelectQuiz(episode.quiz!),
              ),
          ],
        );
      },
    );
  }
}

class ContentItem extends StatelessWidget {
  final EpisodeModel? episode;
  final QuizModel? quiz;
  final VoidCallback onTap;

  const ContentItem.episode({
    super.key,
    required this.episode,
    required this.onTap,
  }) : quiz = null;
  
  const ContentItem.quiz({
    super.key,
    required this.quiz,
    required this.onTap,
  }) : episode = null;

  @override
  Widget build(BuildContext context) {
    if (episode != null) {
      return _buildEpisodeItem(episode!,context);
    } else if (quiz != null) {
      return _buildQuizItem(quiz!);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildEpisodeItem(EpisodeModel episode,BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CustomColors.primary2.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.play_circle_outline, color: CustomColors.primary2),
      ),
      title: Text(
        'Episode ${episode.episodeNumber}: ${episode.title}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            episode.duration,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: const Badge(
                smallSize: 16,
                backgroundColor: Colors.red,
                label: Text('12', style: TextStyle(fontSize: 10)),
                child: Icon(Icons.comment_outlined, color: Colors.blue),
              ),
            ),
            onPressed: () {
              context.pushNamed(Routes.commentScreen,arguments:episode.id );
            },
          ),
          if (episode.isWatched !=null )
          if(episode.isWatched!)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizItem(QuizModel quiz) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.quiz_outlined, color: Colors.amber),
      title: const Text('Quiz'),
      subtitle: Text('${quiz.numOfQuestions} questions'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}