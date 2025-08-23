import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:lottie/lottie.dart';


class Upside extends StatelessWidget {
  const Upside({super.key, required this.imgUrl,required this.canBack});
  final String imgUrl;
  final bool canBack;

  @override
  Widget build(BuildContext context) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height / 2,
          color: isDark? CustomColors.backgroundColor : CustomColors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child:Lottie.asset(
              imgUrl,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        if(canBack)
        iconBackButton(context,isDark),
      ],
    );
  }
}

iconBackButton(BuildContext context,bool isDark) {
  return IconButton(
    color: isDark ? Colors.white : Colors.black ,
    iconSize: 28,
    icon: const Icon(CupertinoIcons.arrow_left),
    onPressed: (){
      context.pop();
    },
  );
}