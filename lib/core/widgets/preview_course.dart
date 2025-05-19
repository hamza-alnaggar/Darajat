import 'package:flutter/material.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Future'),
        ),
        body: Column(
          children: [
            const VideoPreview(),
            TabBar(
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Course content'),
                Tab(text: 'Overview'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const CourseContentTab(),
                  const OverviewTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPreview extends StatelessWidget {
  const VideoPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.image,
              size: 48,
              color: Colors.black26,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 30,
            child: Container(
              width: 20,
              height: 25,
              color: CustomColors.primary2,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
          // Right arrow
          Positioned(
            top: 90,
            bottom:90,
            right: 30,
            child: Container(
              width: 20,
              height: 25,
              color: CustomColors.primary2,
              child: IconButton(
                icon: const Icon(Icons.chevron_right, size: 32),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
          // Play button
        ],
      ),
    );
  }
}

class CourseContentTab extends StatelessWidget {
  const CourseContentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: const [
        Section(
          title: 'Section 1: Introduction',
          total: '2/2 | 1min',
          items: [
            ContentItem(title: 'Quiz 1: Sbxj', isQuiz: true),
            ContentItem(title: '1. Bhjj', duration: '1min'),
          ],
        ),
        Section(
          title: 'Section 2: Vhhh',
          total: '0/1 | 0min',
          items: [
            ContentItem(title: '2. Next Lecture', duration: '0min'),
          ],
        ),
      ],
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String total;
  final List<ContentItem> items;

  const Section({
    required this.title,
    required this.total,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(total),
      children: items,
    );
  }
}

class ContentItem extends StatelessWidget {
  final String title;
  final String? duration;
  final bool isQuiz;

  const ContentItem({
    required this.title,
    this.duration,
    this.isQuiz = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isQuiz
          ? const Icon(Icons.check_box, color: Colors.green)
          : const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
      title: Text(title),
      trailing: duration != null ? Text(duration!) : null,
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('0.0 ★ (0 ratings)'),
          SizedBox(height: 8),
          Text('Students: 0'),
          Text('Published January 1970'),
          Text('Language: English'),
          SizedBox(height: 16),
          Text('By the numbers', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Skill level: --'),
          Text('Students: 0'),
          Text('Languages: English'),
          Text('Captions: No'),
          Text('Lectures: 1'),
        ],
      ),
    );
  }
}
