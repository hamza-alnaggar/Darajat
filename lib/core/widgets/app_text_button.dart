import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class AppTextButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final Widget? buttonIcon;
  final String buttonText;
  final TextStyle? textStyle;
  final VoidCallback onpressed;

  const AppTextButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonIcon,
    required this.buttonText,
    this.textStyle,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textButtonTheme.style!;
    return Container(
      width:size.width*0.8 ,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          CustomColors.primary2,
          CustomColors.primary,
        ]),
          boxShadow: [
      // darker/outer glow
      BoxShadow(
        color: CustomColors.primary.withOpacity(0.6),
        blurRadius: 16.r,
        spreadRadius: 2.r,
        offset: Offset(4, 4.h),
      ),
      // lighter/inner glow
      BoxShadow(
        color: CustomColors.primary2.withOpacity(0.6),
        blurRadius: 8.r,
        spreadRadius: 1.r,
        offset: Offset(2, 2.h),
      ),
    ],
        borderRadius: BorderRadius.circular(borderRadius ?? 29.0.r)
      ),
      child: TextButton(
        style: theme,
        onPressed: onpressed,
        child: 
            Text(
            buttonText,
            style:textStyle ?? theme.textStyle?.resolve({})
            ),
        ),
    );
  }
}
