import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';

class OverviewTab extends StatelessWidget {
  final CourseDetailsModel course;

  const OverviewTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          Row(
            children: [
              Expanded(child: _buildStatCard(
                icon: Icons.star_rate_rounded,
                value: course.rate.courseRating.toStringAsFixed(1),
                label: 'Rating',
                color: Colors.amber,
              )),
              SizedBox(width: 5.w),
              Expanded(child: _buildStatCard(
                icon: Icons.people_alt_outlined,
                value: course.numOfStudentsEnrolled.toString(),
                label: 'Students',
                color: CustomColors.primary2,
              )),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _buildStatCard(
                icon: Icons.video_library_outlined,
                value: course.numOfEpisodes.toString(),
                label: 'Episodes',
                color: Colors.deepPurple,
              )),
              SizedBox(width: 5.w),
              Expanded(child: _buildStatCard(
                icon: Icons.timer_outlined,
                value: _formatTotalDuration(course.numOfHours),
                label: 'Total Duration',
                color: Colors.teal,
              )),
            ],
          ),
          
          SizedBox(height: 25.h),
          
          // Course details
          Text('Course Details', style: theme.headlineSmall),
          SizedBox(height: 15.h),
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            title: 'Published',
            value: _formatDate(course.publishingDate!),
          ),
          _buildDetailRow(
            icon: Icons.timer_outlined,
            title: 'Duration',
            value: _formatTotalDuration(course.numOfHours),
          ),
          _buildDetailRow(
            icon: Icons.language_outlined,
            title: 'Language',
            value: course.language,
          ),
          _buildDetailRow(
            icon: Icons.bar_chart_outlined,
            title: 'Difficulty',
            value: course.difficultyLevel,
          ),
          
          SizedBox(height: 25.h),
          
          // Course description
          Text('Description', style: theme.headlineSmall),
          SizedBox(height: 10.h),
          Text(
            course.description,
            style: theme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.bold,
                color: color
              )),
              Text(label, style: TextStyle(
                fontSize: 14.r,
                color: Colors.grey[600]
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 22.r, color: CustomColors.primary2),
          SizedBox(width: 15.w),
          Text('$title: ', style: TextStyle(
            fontSize: 16.r,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          )),
          Text(value, style: TextStyle(
            fontSize: 16.r,
            fontWeight: FontWeight.w600
          )),
        ],
      ),
    );
  }

  String _formatTotalDuration(int totalHours) {
    return '$totalHours hours';
  }

  String _formatDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date != null) {
      return DateFormat('MMM dd, yyyy').format(date);
    }
    return dateString;
  }
}