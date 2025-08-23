import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class BadgesSection extends StatelessWidget {
  final bool isDark;

  const BadgesSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final earnedBadges = List.filled(8, false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
        borderRadius: BorderRadius.circular(17.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: earnedBadges.length,
          itemBuilder: (context, index) {
            final isEarned = earnedBadges[index];
            return ColorFiltered(
              colorFilter: ColorFilter.matrix(
                isEarned
                    ? [
                        1, 0, 0, 0, 0, //
                        0, 1, 0, 0, 0, //
                        0, 0, 1, 0, 0, //
                        0, 0, 0, 1, 0,
                      ]
                    : [
                        0.2126, 0.7152, 0.0722, 0, 0, //
                        0.2126, 0.7152, 0.0722, 0, 0, //
                        0.2126, 0.7152, 0.0722, 0, 0, //
                        0, 0, 0, 1, 0,
                      ],
              ),
              child: Opacity(
                opacity: isEarned ? 1.0 : 0.6,
                child: Tooltip(
                  message:
                      'To earn this badge you need to complete and submit feedback for 5 peer interviews.',
                  child: Image.asset(
                    'assets/images/badges/century_flame.jpg',
                    width: double.infinity,
                    height: 240.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 20.h),
        ),
      ),
    );
  }
}



