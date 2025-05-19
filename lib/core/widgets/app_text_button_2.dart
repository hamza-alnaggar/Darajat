import 'package:flutter/material.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class AppTextButton2 extends StatelessWidget {
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

  const AppTextButton2({
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
    
    final theme = Theme.of(context).textButtonTheme.style!;
    return Container(
      
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          CustomColors.primary2,
          CustomColors.primary,
        ]),
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
