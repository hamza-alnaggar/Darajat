import 'package:flutter/material.dart';

import 'package:learning_management_system/core/theming/bottom_app_bar_size.dart';
import 'package:learning_management_system/core/theming/colors.dart';

double animatedPositionedLEftValue(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return BottomAppBarSize.blockSizeHorizontal * 7.5;
    case 1:
      return BottomAppBarSize.blockSizeHorizontal * 28.5;
    case 2:
      return BottomAppBarSize.blockSizeHorizontal * 49.5;
    case 3:
      return BottomAppBarSize.blockSizeHorizontal * 71.0;

    default:
      return 0;
  }
}

final List<Color> gradient = [
  CustomColors.primary.withOpacity(0.5),
  CustomColors.primary2.withOpacity(0.8),
  Colors.transparent
];