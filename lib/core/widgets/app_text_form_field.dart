import 'package:flutter/material.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final IconData ?icon;
  final Function(String?)? validator;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal:20,vertical:10),
      width: size.width *0.8,
      decoration: BoxDecoration(
        color:CustomColors.secondary,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          icon: Icon(
            icon,
            color: CustomColors.primary2,
          ),
          // contentPadding: contentPadding ??
          //     inputDecorationTheme.contentPadding ??
          //     EdgeInsets.symmetric(
          //       horizontal: 20.w,
          //       vertical: 18.h,
          //     ),
          hintText: hintText,
          hintStyle: hintStyle ?? inputDecorationTheme.hintStyle,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: backgroundColor ??
              inputDecorationTheme.fillColor ,
          border: inputDecorationTheme.border,
          // enabledBorder: enabledBorder ?? inputDecorationTheme.enabledBorder,
          // focusedBorder: focusedBorder ?? inputDecorationTheme.focusedBorder,
          // errorBorder: inputDecorationTheme.errorBorder,
          // focusedErrorBorder: inputDecorationTheme.focusedErrorBorder,
          errorStyle: inputDecorationTheme.errorStyle,
          errorMaxLines: inputDecorationTheme.errorMaxLines,
          prefixIconColor: inputDecorationTheme.prefixIconColor,
          suffixIconColor: inputDecorationTheme.suffixIconColor,
        ),
        obscureText: isObscureText ?? false,
        style: inputTextStyle ?? inputDecorationTheme.labelStyle,
        validator: (value) => validator?.call(value),
      ),
    );
  }
}