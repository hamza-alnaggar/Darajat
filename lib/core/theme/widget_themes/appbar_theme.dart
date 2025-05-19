import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/theming/sizes.dart';


class CustomAppBarTheme{
  CustomAppBarTheme._();

  static var lightAppBarTheme = AppBarTheme(
    elevation: 3,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: CustomColors.primary2,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: CustomColors.black, size: CustomSizes.iconMd),
    actionsIconTheme: IconThemeData(color: CustomColors.black, size: CustomSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 25.0.sp, fontWeight: FontWeight.bold, color: CustomColors.textPrimary),
  );
  static var darkAppBarTheme = AppBarTheme(
    elevation: 3,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: CustomColors.secondary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: CustomColors.black, size: CustomSizes.iconMd),
    actionsIconTheme: IconThemeData(color: CustomColors.white, size: CustomSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 25.0.sp, fontWeight: FontWeight.bold, color: CustomColors.textPrimary),
  );
}