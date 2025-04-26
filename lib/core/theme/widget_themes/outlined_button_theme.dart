import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/theming/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class CustomOutlinedButtonTheme {
  CustomOutlinedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: CustomColors.dark,
      side: const BorderSide(color: CustomColors.borderPrimary),
      textStyle:  TextStyle(fontSize: 16.sp, color: CustomColors.black, fontWeight: FontWeight.w600),
      padding:  EdgeInsets.symmetric(vertical: CustomSizes.buttonHeight, horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: CustomColors.light,
      side: const BorderSide(color: CustomColors.borderPrimary),
      textStyle:  TextStyle(fontSize: 16.sp, color: CustomColors.textWhite, fontWeight: FontWeight.w600),
      padding:  EdgeInsets.symmetric(vertical: CustomSizes.buttonHeight, horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomSizes.buttonRadius)),
    ),
  );
}
