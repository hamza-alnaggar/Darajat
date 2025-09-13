import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:16.w ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Categories',
            style:theme.headlineMedium
          ),
          TextButton(
            onPressed: () {
              context.pushNamed(Routes.categoryScreen);
            },
            child: Text(
              'See All',
              style:theme.titleSmall?.copyWith(
                color: CustomColors.primary2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}