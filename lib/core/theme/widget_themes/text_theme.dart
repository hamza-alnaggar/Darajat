import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

/// Custom Class for Light & Dark Text Themes
class CustomTextTheme {
  CustomTextTheme._(); // To avoid creating instances

  /// Customizable Light Text Theme
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge:  TextStyle().copyWith(fontSize: 32.0.sp, fontWeight: FontWeight.bold, color: CustomColors.dark),
    headlineMedium:  TextStyle().copyWith(fontSize: 24.0.sp, fontWeight: FontWeight.w600, color: CustomColors.dark),
    headlineSmall:  TextStyle().copyWith(fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: CustomColors.dark),

    titleLarge:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: CustomColors.dark),
    titleMedium:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: CustomColors.dark),
    titleSmall:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w400, color: CustomColors.dark),

    bodyLarge:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: CustomColors.dark),
    bodyMedium:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.normal, color: CustomColors.dark),
    bodySmall:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: CustomColors.dark.withOpacity(0.5)),

    labelLarge:  TextStyle().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: CustomColors.dark),
    labelMedium:  TextStyle().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: CustomColors.dark.withOpacity(0.5)),
  );

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge:  TextStyle().copyWith(fontSize: 32.0.sp, fontWeight: FontWeight.bold, color: CustomColors.light),
    headlineMedium:  TextStyle().copyWith(fontSize: 24.0.sp, fontWeight: FontWeight.w600, color: CustomColors.light),
    headlineSmall:  TextStyle().copyWith(fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: CustomColors.light),

    titleLarge:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: CustomColors.light),
    titleMedium:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: CustomColors.light),
    titleSmall:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w400, color: CustomColors.light),

    bodyLarge:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: CustomColors.light),
    bodyMedium:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.normal, color: CustomColors.light),
    bodySmall:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: CustomColors.light.withOpacity(0.5)),

    labelLarge:  TextStyle().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: CustomColors.light),
    labelMedium:  TextStyle().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: CustomColors.light.withOpacity(0.5)),
  );
}
