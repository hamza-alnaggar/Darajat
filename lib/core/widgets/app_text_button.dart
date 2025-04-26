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
  final TextStyle textStyle;
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
    required this.textStyle,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width:size.width*0.8 ,
      decoration: BoxDecoration(
        boxShadow: [
        ],
        gradient: LinearGradient(colors: [
          CustomColors.primary2,
          CustomColors.primary,
          
        ]),
        borderRadius: BorderRadius.circular(borderRadius ?? 25.0.r)
      ),
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 16.0.r),
            ),
          ),
          // backgroundColor: WidgetStateProperty.all(
          //   backgroundColor ?? Colors.black,
          // ),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: horizontalPadding?.w ?? 12.w,
              vertical: verticalPadding?.h ?? 10.h,
            ),
          ),
          minimumSize: WidgetStateProperty.all(Size(0, buttonHeight ?? 50.h)),
        ),
        onPressed: onpressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(buttonText, style: textStyle),
            SizedBox(width: 10.w),
            buttonIcon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
