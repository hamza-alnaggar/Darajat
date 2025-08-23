import 'package:flutter/material.dart';

import 'package:learning_management_system/core/theming/bottom_app_bar_size.dart';
import 'package:learning_management_system/core/theming/colors.dart';

double animatedPositionedLeftValue(int currentIndex, BuildContext context) {
  final bool isRTL = Directionality.of(context) == TextDirection.rtl;
  final double baseValue = BottomAppBarSize.blockSizeHorizontal;
  
  // Define positions for LTR
  final Map<int, double> ltrPositions = {
    0: baseValue * 7.5,
    1: baseValue * 28.5,
    2: baseValue * 49.5,
    3: baseValue * 71.0,
  };

  if (isRTL) {
    final totalWidth = MediaQuery.of(context).size.width;
    final indicatorWidth = baseValue * 21;
    
    return totalWidth - ltrPositions[currentIndex]! - indicatorWidth;
  } else {
    return ltrPositions[currentIndex] ?? 0;
  }
}
final List<Color> gradient = [
  CustomColors.primary.withOpacity(0.5),
  CustomColors.primary2.withOpacity(0.8),
  Colors.transparent
];