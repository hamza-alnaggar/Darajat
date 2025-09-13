import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final int ?maxLength;
  final String ?counterText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final IconData ?icon;
  final Function(String?)? validator;
  final Function(String?)? onChange;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.counterText,
    this.maxLength,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    this.onChange,
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
     final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal:20.w,vertical:10.h),
      width: size.width *0.8,
      decoration: BoxDecoration(
        color: isDark? CustomColors.secondary : Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(29.r),
      ),
      child: TextFormField(
        onChanged: (value) => onChange?.call(value),
        maxLength: maxLength,
        controller: controller,
        decoration: InputDecoration(
          counterText: counterText,
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