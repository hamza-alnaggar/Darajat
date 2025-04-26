import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/theming/sizes.dart';


class CustomAppBarTheme{
  CustomAppBarTheme._();

  static var lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: CustomColors.black, size: CustomSizes.iconMd),
    actionsIconTheme: IconThemeData(color: CustomColors.black, size: CustomSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: CustomColors.black),
  );
  static var darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: CustomColors.black, size: CustomSizes.iconMd),
    actionsIconTheme: IconThemeData(color: CustomColors.white, size: CustomSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: CustomColors.white),
  );
}