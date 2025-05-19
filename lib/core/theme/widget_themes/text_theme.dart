import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

/// Custom Class for Light & Dark Text Themes
class CustomTextTheme {
  CustomTextTheme._(); // To avoid creating instances

  /// Customizable Light Text Theme
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge:  TextStyle().copyWith(fontSize: 32.0.sp, fontWeight: FontWeight.bold, color: CustomColors.textDark),
    headlineMedium:  TextStyle().copyWith(fontSize: 24.0.sp, fontWeight: FontWeight.w600, color: CustomColors.textDark),
    headlineSmall:  TextStyle().copyWith(fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: CustomColors.textDark),

    titleLarge:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: CustomColors.textDark),
    titleMedium:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: CustomColors.textDark),
    titleSmall:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w400, color: CustomColors.textDark),

    bodyLarge:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: CustomColors.textDark),
    bodyMedium:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.normal, color: CustomColors.textDark),
    bodySmall:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w400, color: CustomColors.textDark.withOpacity(0.5)),

    labelLarge:  TextStyle().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: CustomColors.textDark),
    labelMedium:  TextStyle().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: CustomColors.textSecondary),
  );

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge:  TextStyle().copyWith(fontSize: 32.0.sp, fontWeight: FontWeight.bold, color: CustomColors.textPrimary),
    headlineMedium:  TextStyle().copyWith(fontSize: 24.0.sp, fontWeight: FontWeight.w600, color: CustomColors.textPrimary),
    headlineSmall:  TextStyle().copyWith(fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: CustomColors.textPrimary),

    titleLarge:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: CustomColors.textPrimary),
    titleMedium:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: CustomColors.textPrimary),
    titleSmall:  TextStyle().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w400, color: CustomColors.textPrimary),

    bodyLarge:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: CustomColors.textPrimary),
    bodyMedium:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.normal, color: CustomColors.textPrimary),
    bodySmall:  TextStyle().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: CustomColors.textPrimary.withOpacity(0.5)),

    labelLarge:  TextStyle().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: CustomColors.textPrimary),
    labelMedium:  TextStyle().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: CustomColors.textSecondary),
  );
}
