import 'package:flutter/material.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 13,
              color: CustomColors.neutralColor,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () {
            onTap();
          },
          child: Text(
            navigatorText,
            style: const TextStyle(
                color: CustomColors.primary2,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Opensans'),
          ),
        )
      ],
    );
  }
}