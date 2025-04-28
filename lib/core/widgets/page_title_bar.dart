import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class PageTitleBar extends StatelessWidget {
  const PageTitleBar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 260.0.h),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColors.primary, CustomColors.primary2],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(top: 16.0.h),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style:theme.textTheme.headlineMedium?.copyWith(
            letterSpacing: 1
            ),
            ),
          ),
        ),
      );
  }
}
