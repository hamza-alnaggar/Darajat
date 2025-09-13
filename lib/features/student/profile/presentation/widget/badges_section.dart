import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/badges/data/models/badge_model.dart';
import 'package:learning_management_system/features/badges/data/models/bages_data_model.dart';
import 'package:learning_management_system/features/badges/data/repositories/badges_repository.dart';
import 'package:learning_management_system/features/badges/presentation/cubit/badges_cubit.dart';
import 'package:learning_management_system/features/badges/presentation/cubit/badges_state.dart';

class BadgesSection extends StatelessWidget {
  final bool isDark;

  const BadgesSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BadgesCubit(repository: sl<BadgesRepository>())..getBadges(),
      child: _BadgesSectionContent(isDark: isDark),
    );
  }
}

class _BadgesSectionContent extends StatelessWidget {
  final bool isDark;

  const _BadgesSectionContent({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
        borderRadius: BorderRadius.circular(17.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: BlocBuilder<BadgesCubit, BadgesState>(
          builder: (context, state) {
            if (state is BadgesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BadgesFailure) {
              return Center(child: Text(state.errMessage));
            } else if (state is BadgesSuccess) {
              return _buildBadgesGrid(state.badges.data);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildBadgesGrid(BadgesDataModel badges) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildBadgeCategory('Gold Badges', badges.gold, isDark),
        SizedBox(height: 40.h),
        _buildBadgeCategory('Silver Badges', badges.silver, isDark),
        SizedBox(height: 40.h),
        _buildBadgeCategory('Bronze Badges', badges.bronze, isDark),
      ],
    );
  }

  Widget _buildBadgeCategory(String title, List<BadgeModel> badges, bool isDark) {
    if (badges.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        for(int i=0 ;i<badges.length;i++)
        Center(child: Column(
          children: [
            _BadgeItem(badge: badges[i], isDark: isDark),
            SizedBox(height: 20.h,),
          ],
        ))
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final BadgeModel badge;
  final bool isDark;

  const _BadgeItem({required this.badge, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.network(
        badge.imageUrl,
        width: 200.w,
        height: 200.h,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, progress) => progress == null
            ? child
            : SizedBox(
                width: 200.w,
                height: 200.h,
                child: Center(child: CircularProgressIndicator()),
              ),
        errorBuilder: (ctx, err, stack) => Container(
          width: 200.w,
          height: 200.h,
          alignment: Alignment.center,
          child: Icon(Icons.broken_image),
        ),
      ),
    );

    if (badge.gotTheBadge == true) {
      return Tooltip(
        message: badge.description,
        child: Column(
          children: [
            Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: image,
            ),
            SizedBox(height: 8.h),
            _badgeLabel(),
          ],
        ),
      );
    } else {
      return Tooltip(
        message: badge.description,
        child: Column(
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 1, 0,
              ]),
              child: Opacity(
                opacity: 0.6,
                child: Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: image,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            _badgeLabel(),
          ],
        ),
      );
    }
  }

  Widget _badgeLabel() => Text(
    badge.group,
    style: TextStyle(
      fontSize: 19.sp,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : Colors.black54,
    ),
    textAlign: TextAlign.center,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}
