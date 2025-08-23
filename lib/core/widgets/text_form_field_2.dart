import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class TextFormField2 extends StatelessWidget {
    final TextEditingController? controller;
    final int? maxLength;
    final String? hint;
    final int? minLines;


  const TextFormField2({super.key,this.minLines,this.controller,this.hint,this.maxLength});

  @override
  Widget build(BuildContext context) {
      final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return  SizedBox(
      child: TextField(
        minLines: minLines ?? 1,
        maxLines: 100,
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(
                    color: Colors.grey
                  )
                  ),
                  fillColor:isDark?CustomColors.secondary: CustomColors.white ,
                  filled: true,
                  border: const OutlineInputBorder(),
                  counterText:'${controller?.text.length}',
                  hintText: hint,
                  hintStyle: TextStyle(color: CustomColors.textSecondary)
                ),
                maxLength: maxLength,
              ),
    );
  }
}