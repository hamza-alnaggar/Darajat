import 'package:flutter/material.dart';
import 'package:learning_management_system/core/theming/bottom_app_bar_size.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class BottomNavBTN extends StatelessWidget {
  final Function(int) onPressed;
  final IconData icon;
  final int index;
  final int currentIndex;

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
  const BottomNavBTN({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    BottomAppBarSize().init(context);
    return InkWell(
      onTap: () {
        onPressed(index);
      },
      child: Container(
        height: BottomAppBarSize.blockSizeHorizontal * 13,
        width: BottomAppBarSize.blockSizeHorizontal * 17,
        decoration: const BoxDecoration(
          //color: Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            (currentIndex == index)
                ? Positioned(
                    left: BottomAppBarSize.blockSizeHorizontal * 4,
                    bottom: BottomAppBarSize.blockSizeHorizontal * 1.5,
                    child: Icon(
                      icon,
                      color: Colors.black,
                      size: BottomAppBarSize.blockSizeHorizontal * 8,
                    ),
                  )
                : Container(),
            AnimatedOpacity(
              opacity: (currentIndex == index) ? 1 : 0.2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: Icon(
                icon,
                color:  CustomColors.primary2,
                size: BottomAppBarSize.blockSizeHorizontal * 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}