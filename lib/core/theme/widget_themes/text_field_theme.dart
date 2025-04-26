import 'package:flutter/material.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/theming/sizes.dart';


class CustomTextFormFieldTheme {
  CustomTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: CustomColors.neutralColor,
    suffixIconColor: CustomColors.neutralColor,
    fillColor: CustomColors.secondary,
    filled: true,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: CustomSizes.fontSizeMd, color: CustomColors.neutralColor),
    hintStyle: const TextStyle().copyWith(fontSize: CustomSizes.fontSizeSm, color: CustomColors.textSecondary),
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
    labelStyle: const TextStyle().copyWith(fontSize: CustomSizes.fontSizeMd, color: CustomColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: CustomSizes.fontSizeSm, color: CustomColors.textSecondary),
    floatingLabelStyle: const TextStyle().copyWith(color: CustomColors.white.withOpacity(0.8)),
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
