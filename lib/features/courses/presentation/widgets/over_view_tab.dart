// Updated OverviewTab + RateCourseScreen (single file)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';

import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/rate_course_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/rate_course_cubit.dart';

// New imports for certificate flow
import 'package:learning_management_system/features/courses/presentation/cubit/get_certificate_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_certificate_state.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewTab extends StatefulWidget {
  final CourseDetailsModel course;

  const OverviewTab({super.key, required this.course});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  late double _displayRating;
  int? _userRating; 

  @override
  void initState() {
    super.initState();
    _displayRating = double.parse(widget.course.rate.courseRating.toString());
  }

  Future<void> _openCertificateLink(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Oops',
          message: 'Invalid certificate link.',
          contentType: ContentType.warning,
          color: CustomColors.backgroundColor,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Could not open',
          message: 'Unable to open certificate link.',
          contentType: ContentType.failure,
          color: CustomColors.backgroundColor,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return BlocProvider<GetCertificateCubit>(
      create: (_) => sl<GetCertificateCubit>(),
      child: BlocConsumer<RateCourseCubit, RateCourseState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.star_rate_rounded,
                        value: _displayRating.toStringAsFixed(1),
                        label: 'Rating',
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.people_alt_outlined,
                        value: widget.course.numOfStudentsEnrolled.toString(),
                        label: 'Students',
                        color: CustomColors.primary2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.video_library_outlined,
                        value: widget.course.numOfEpisodes.toString(),
                        label: 'Episodes',
                        color: CustomColors.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.timer_outlined,
                        value: _formatTotalDuration(widget.course.numOfHours),
                        label: 'Total Duration',
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),

                // Course details
                Text('Course Details', style: theme.headlineSmall),
                SizedBox(height: 15.h),
                _buildDetailRow(
                  icon: Icons.calendar_today_outlined,
                  title: 'Published',
                  value: _formatDate(widget.course.publishingDate!),
                ),
                _buildDetailRow(
                  icon: Icons.timer_outlined,
                  title: 'Duration',
                  value: _formatTotalDuration(widget.course.numOfHours),
                ),
                _buildDetailRow(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  value: widget.course.language.name,
                ),
                _buildDetailRow(
                  icon: Icons.bar_chart_outlined,
                  title: 'Difficulty',
                  value: widget.course.difficultyLevel,
                ),
                SizedBox(height: 25.h),

                Text('Rate this course', style: theme.headlineSmall),
                SizedBox(height: 10.h),

                Row(
                  children: [
                    _buildReadOnlyStars(),
                    const SizedBox(width: 12),
                    Expanded(child: Container()),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push<int?>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => sl<RateCourseCubit>(),
                              child: RateCourseScreen(courseId: widget.course.id),
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() => _userRating = result);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.secondary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.rate_review_outlined, color: Colors.white,),
                      label: Text('Rate', style: TextStyle(fontSize: 16.r, color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),

                Text('Certificate', style: theme.headlineSmall),
                SizedBox(height: 12.h),
                BlocConsumer<GetCertificateCubit, GetCertificateState>(
                  listener: (context, certState) {
                    if (certState is GetCertificateSuccess) {
                      // Open the certificate link when we receive it.
                      _openCertificateLink(certState.link);
                    } else if (certState is GetCertificateFailure) {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Certificate',
                          message: certState.errMessage,
                          contentType: ContentType.failure,
                          color: CustomColors.backgroundColor,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
                  builder: (context, certState) {
                    final isLoading = certState is GetCertificateLoading;

                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tap the button to earn or view your certificate ',
                            style: theme.bodyMedium,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: isLoading ? null : () {
                            context.read<GetCertificateCubit>().getCertificate(widget.course.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.secondary,
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 18.h,
                                  width: 18.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  children: [
                                    Icon(Icons.card_membership_outlined, size: 18, color: Colors.white),
                                    SizedBox(width: 8.w),
                                    Text('Earn / View', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 25.h),

                // Course - remainder of content...
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReadOnlyStars() {
    final int highlightUpTo = _userRating ?? _displayRating.round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isHighlighted = starIndex <= highlightUpTo;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Icon(
            isHighlighted ? Icons.star : Icons.star_border,
            size: 28.r,
            color: isHighlighted ? Colors.amber : Colors.white70,
          ),
        );
      }),
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
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.r,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 14.r, color: Colors.grey[600]),
              ),
            ],
          ),
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
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 16.r,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.r, color:CustomColors.textSecondary,fontWeight: FontWeight.w600),
          ),
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

class RateCourseScreen extends StatefulWidget {
  final int courseId;

  const RateCourseScreen({super.key, required this.courseId});

  @override
  State<RateCourseScreen> createState() => _RateCourseScreenState();
}

class _RateCourseScreenState extends State<RateCourseScreen>
    with SingleTickerProviderStateMixin {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return BlocConsumer<RateCourseCubit, RateCourseState>(
      listener: (context, state) {
        if (state is RateCourseSuccess) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Thanks! 🎉',
              message: state.message,
              contentType: ContentType.success,
              color: CustomColors.backgroundColor,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Future.delayed(const Duration(milliseconds: 400), () {
            Navigator.pop(context, _selectedRating);
          });
        } else if (state is RateCourseFailure) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'On Snap!',
              message: state.errMessage,
              contentType: ContentType.failure,
              color: CustomColors.backgroundColor,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        final isLoading = state is RateCourseLoading;

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Rate Course'
           
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How was the course?', style: theme.headlineSmall),
                SizedBox(height: 12.h),
                Text(
                  'Tap a star and add an optional comment to help others.',
                  style: theme.bodyMedium,
                ),
                SizedBox(height: 18.h),

                // Big star selector
                Center(child: _buildInteractiveStars()),
                SizedBox(height: 20.h),

                SizedBox(height: 20.h),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedRating == 0 || isLoading)
                        ? null
                        : () {
                            context.read<RateCourseCubit>().rateCourse(
                              widget.courseId,
                              _selectedRating,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.secondary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 18.h,
                            width: 18.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Submit Rating',
                            style: TextStyle(fontSize: 16.r, color: Colors.white),
                          ),
                  ),
                ),

                SizedBox(height: 10.h),

                // Cancel
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 15.r, color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInteractiveStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isSelected = starIndex <= _selectedRating;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedRating = starIndex);
            _animController.forward(from: 0.0);
          },
          child: AnimatedScale(
            scale: isSelected ? 1.14 : 1.0,
            duration: const Duration(milliseconds: 180),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Icon(
                isSelected ? Icons.star : Icons.star_border,
                size: 46.r,
                color: isSelected ? Colors.amber : Colors.grey.shade400,
              ),
            ),
          ),
        );
      }),
    );
  }
}
