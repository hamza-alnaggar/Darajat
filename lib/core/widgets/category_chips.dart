import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

    static List<String> categories = [
    'Development',
    'IT & Software',
    'Office Prod.',
    'Business',
    'Finance & Accounting',
    'Personal Dev.'
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      direction: Axis.horizontal,
      children: categories.map((cat) {
        return Chip(
          label: Text(cat,),
          shape: StadiumBorder(
            side: BorderSide(color:isDark? Colors.white : Colors.black),
          ),
        );
      }).toList(),
    );
  }
}