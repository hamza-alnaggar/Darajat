import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/theming/sizes.dart';


class CustomTextFormFieldTheme {
  CustomTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: CustomColors.textPrimary,
    suffixIconColor: CustomColors.textPrimary,
    fillColor: CustomColors.secondary,
    filled: true,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: TextStyle().copyWith(fontSize:16.sp, color: CustomColors.textPrimary),
    hintStyle:  TextStyle().copyWith(fontSize:14.sp, color: CustomColors.textSecondary),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    border: InputBorder.none,
    // enabledBorder: const OutlineInputBorder().copyWith(
    //   borderRadius: BorderRadius.circular(CustomSizes.inputFieldRadius),
    //   borderSide: const BorderSide(width: 1, color: CustomColors.grey),
    // ),
    // focusedBorder:const OutlineInputBorder().copyWith(
    //   borderRadius: BorderRadius.circular(CustomSizes.inputFieldRadius),
    //   borderSide: const BorderSide(width: 1, color: CustomColors.dark),
    // ),
    // errorBorder: const OutlineInputBorder().copyWith(
    //   borderRadius: BorderRadius.circular(CustomSizes.inputFieldRadius),
    //   borderSide: const BorderSide(width: 1, color: CustomColors.warning),
    // ),
    // focusedErrorBorder: const OutlineInputBorder().copyWith(
    //   borderRadius: BorderRadius.circular(CustomSizes.inputFieldRadius),
    //   borderSide: const BorderSide(width: 2, color: CustomColors.warning),
    // ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: CustomColors.darkGrey,
    suffixIconColor: CustomColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle:  TextStyle().copyWith(fontSize:16.sp, color: CustomColors.white),
    hintStyle:  TextStyle().copyWith(fontSize: 14.sp, color: CustomColors.textSecondary),
    border: InputBorder.none,
    fillColor: CustomColors.secondary,
    filled: true,
    // enabledBorder: const OutlineInputBorder().copyWith(
    //   borderRadius: BorderRadius.circular(CustomSizes.inputFieldRadius),
    //   borderSide: const BorderSide(width: 1, color: CustomColors.darkGrey),
    // ),
    // focusedBorder: const OutlineInputBorder().copyWith(
    //   borderRadius: BorderRadius.circular(CustomSizes.inputFieldRadius),
    //   borderSide: const BorderSide(width: 1, color: CustomColors.white),
    // ),
    // errorBorder: const OutlineInputBorder().copyWith(
    //   borderRadius: BorderRadius.circular(CustomSizes.inputFieldRadius),
    //   borderSide: const BorderSide(width: 1, color: CustomColors.warning),
    // ),
    // focusedErrorBorder: const OutlineInputBorder().copyWith(
    //   borderRadius: BorderRadius.circular(CustomSizes.inputFieldRadius),
    //   borderSide: const BorderSide(width: 2, color: CustomColors.warning),
    // ),
  );
}
