import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class CustomChipTheme {
  CustomChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: CustomColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: CustomColors.black),
    backgroundColor: CustomColors.white,
    selectedColor: CustomColors.primary,
    padding:  EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.h),
    checkmarkColor: CustomColors.white,
  );

  static ChipThemeData darkChipTheme =  ChipThemeData(
    backgroundColor: CustomColors.backgroundColor,
    disabledColor: CustomColors.darkerGrey,
    labelStyle: TextStyle(color: CustomColors.textPrimary),
    selectedColor: CustomColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.h),
    checkmarkColor: CustomColors.white,
  );
}
