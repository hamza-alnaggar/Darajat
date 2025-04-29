import 'package:flutter/material.dart';

import 'package:learning_management_system/core/theming/bottom_app_bar_size.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/sample_widget.dart';

List<Widget> screens = [
  const SampleWidget(
    label: 'HOME',
    color: CustomColors.backgroundColor,
  ),
  const SampleWidget(
    label: 'SEARCH',
    color: CustomColors.backgroundColor,
  ),
  const SampleWidget(
    label: 'EXPLORE',
    color: CustomColors.backgroundColor,
  ),
  const SampleWidget(
    label: 'SETTINGS',
    color: CustomColors.backgroundColor,
  ),
  const SampleWidget(
    label: 'PROFILE',
    color: CustomColors.backgroundColor,
  ),
];

double animatedPositionedLEftValue(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return BottomAppBarSize.blockSizeHorizontal * 5.5;
    case 1:
      return BottomAppBarSize.blockSizeHorizontal * 22.5;
    case 2:
      return BottomAppBarSize.blockSizeHorizontal * 39.5;
    case 3:
      return BottomAppBarSize.blockSizeHorizontal * 56.5;
    case 4:
      return BottomAppBarSize.blockSizeHorizontal * 73.5;
    default:
      return 0;
  }
}
//
// Created by CodeWithFlexZ
// Tutorials on my YouTube
//
//! Instagram
//! @CodeWithFlexZ
//
//? GitHub
//? AmirBayat0
//
//* YouTube
//* Programming with FlexZ
//

final List<Color> gradient = [
  CustomColors.primary.withOpacity(0.5),
  CustomColors.primary2.withOpacity(0.8),
  Colors.transparent
];