import 'package:flutter/material.dart';
import 'package:learning_management_system/core/helper/spacing.dart';
import 'package:learning_management_system/core/theming/colors.dart';


class UnderPart extends StatelessWidget {
  const UnderPart(
      {super.key,
      required this.title,
      required this.navigatorText,
      required this.onTap});
  final String title;
  final String navigatorText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge
        ),
        horizontalSpace(20),
        InkWell(
          onTap: () {
            onTap();
          },
          child: Text(
            navigatorText,
            style: theme.textTheme.bodyLarge?.copyWith(
            color: CustomColors.primary2
          ), 
          ),
        )
      ],
    );
  }
}