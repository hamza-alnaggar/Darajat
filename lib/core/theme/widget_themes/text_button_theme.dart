import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

/* -- Light & Dark Elevated Button Themes -- */
class CustomTextButtonTheme {
  CustomTextButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      disabledForegroundColor: CustomColors.darkGrey,
      disabledBackgroundColor: CustomColors.buttonDisabled,
      //padding: const EdgeInsets.symmetric(vertical: CustomSizes.buttonHeight),
      textStyle:  TextStyle(fontSize: 20.sp, color: CustomColors.textPrimary, fontWeight: FontWeight.bold),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      disabledForegroundColor: CustomColors.darkGrey,
      disabledBackgroundColor: CustomColors.darkerGrey,
     // padding: const EdgeInsets.symmetric(vertical: CustomSizes.buttonHeight),
      textStyle:  TextStyle(fontSize: 20.sp, color: CustomColors.textPrimary, fontWeight: FontWeight.bold),
    
    ),
  );
}
