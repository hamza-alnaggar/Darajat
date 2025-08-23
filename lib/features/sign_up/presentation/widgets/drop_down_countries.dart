import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class CustomDropDown<T> extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.selectedVal,
    required this.list,
    required this.hint,
    required this.itemToString,
    required this.onChanged,
  });

  final T? selectedVal;
  final List<T> list;
  final String hint;
  final String Function(T) itemToString;
  final Function(T?)? onChanged;

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              Icons.list, // Generic icon, customize if needed
              size: 20.r,
              color: CustomColors.primary2,
            ),
            SizedBox(width: 8.w),
            Text(
              widget.hint,
              style: TextStyle(
                fontSize: 16.r,
                color: CustomColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        buttonStyleData: ButtonStyleData(
          height: 50.h,
          width: 250.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
            ),
            borderRadius: BorderRadius.circular(12.r),
            color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
          ),
          elevation: 3,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: CustomColors.primary2,
          ),
          iconSize: 28.r,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
          ),
          maxHeight: 250.h,
          width: 250.w,
          offset: const Offset(0, -4),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        items: widget.list
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.itemToString(item),
                        style: TextStyle(
                          fontSize: 16.r,
                          color: CustomColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.selectedVal == item)
                        Icon(
                          Icons.check_circle,
                          color: CustomColors.primary,
                          size: 18.r,
                        ),
                    ],
                  ),
                ))
            .toList(),
        value: widget.selectedVal,
        onChanged: widget.onChanged,
      ),
    );
  }
}