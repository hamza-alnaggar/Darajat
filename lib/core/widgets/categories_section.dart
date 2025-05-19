import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categories',
          style:theme.headlineMedium
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'See all',
            style:theme.titleSmall?.copyWith(
              color: Colors.purpleAccent,
            ),
          ),
        ),
      ],
    );
  }
}