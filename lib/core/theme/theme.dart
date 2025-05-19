import 'package:flutter/material.dart';
import 'package:learning_management_system/core/theme/widget_themes/appbar_theme.dart';
import 'package:learning_management_system/core/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:learning_management_system/core/theme/widget_themes/checkbox_theme.dart';
import 'package:learning_management_system/core/theme/widget_themes/chip_theme.dart';
import 'package:learning_management_system/core/theme/widget_themes/text_button_theme.dart';
import 'package:learning_management_system/core/theme/widget_themes/outlined_button_theme.dart';
import 'package:learning_management_system/core/theme/widget_themes/text_field_theme.dart';
import 'package:learning_management_system/core/theme/widget_themes/text_theme.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class CustomAppTheme {
  CustomAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    disabledColor: CustomColors.grey,
    brightness: Brightness.light,
    primaryColor: CustomColors.primary,
    textTheme: CustomTextTheme.lightTextTheme,
    chipTheme: CustomChipTheme.lightChipTheme,
    scaffoldBackgroundColor: CustomColors.white,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme,
    checkboxTheme: CustomCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: CustomBottomSheetTheme.lightBottomSheetTheme,
    textButtonTheme: CustomTextButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: CustomTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    disabledColor: CustomColors.grey,
    brightness: Brightness.dark,
    primaryColor: CustomColors.primary,
    textTheme: CustomTextTheme.darkTextTheme,
    chipTheme: CustomChipTheme.darkChipTheme,
    scaffoldBackgroundColor: CustomColors.backgroundColor,
    appBarTheme: CustomAppBarTheme.darkAppBarTheme,
    checkboxTheme: CustomCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: CustomBottomSheetTheme.darkBottomSheetTheme,
    textButtonTheme: CustomTextButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: CustomTextFormFieldTheme.darkInputDecorationTheme,
  );
}
