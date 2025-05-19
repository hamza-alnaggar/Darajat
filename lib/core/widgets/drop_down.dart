import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? selectedValue;
  List<String> items = ['Male', 'Female', "Ai", "Robot", "Ghost"];
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return  DropdownButtonHideUnderline(
                                                                        child: DropdownButton2(
                                                                          isExpanded:
                                                                              true,
                                                                          hint: Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.person_outlined,
                                                                                size:
                                                                                    20.r,
                                                                                color:
                                                                                    CustomColors.primary2,
                                                                              ),
                                                                              SizedBox(
                                                                                width:
                                                                                    8.w,
                                                                              ),
                                                                              Text(
                                                                                "Choose gender",
                                                                                style: TextStyle(
                                                                                  fontSize:
                                                                                      16.r,
                                                                                  color:
                                                                                      CustomColors.textSecondary,
                                                                                  fontWeight:
                                                                                      FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          buttonStyleData: ButtonStyleData(
                                                                            height:
                                                                                50.h,
                                                                            width:
                                                                                250.w,
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  16.w,
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                color:
                                                                                    isDark?CustomColors.secondary:CustomColors.lightContainer,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(
                                                                                12.r,
                                                                              ),
                                                                              color:
                                                                                  isDark?CustomColors.secondary:CustomColors.lightContainer,
                                                                            ),
                                                                            elevation:
                                                                                3,
                                                                          ),
                                                                          iconStyleData: IconStyleData(
                                                                            icon: Icon(
                                                                              Icons.arrow_drop_down,
                                                                              color:
                                                                                  CustomColors.primary2,
                                                                            ),
                                                                            iconSize:
                                                                                28.r,
                                                                          ),
                                                                          dropdownStyleData: DropdownStyleData(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                12.r,
                                                                              ),
                                                                              color:
                                                                                  isDark?CustomColors.secondary:CustomColors.lightContainer,
                                                                            ),
                                                                            maxHeight:
                                                                                250.h,
                                                                            width:
                                                                                250.w,
                                                                            offset: Offset(
                                                                              0,
                                                                              -4,
                                                                            ),
                                                                            scrollbarTheme: ScrollbarThemeData(
                                                                              radius: Radius.circular(
                                                                                40.r,
                                                                              ),
                                                                              thickness: WidgetStateProperty.all(
                                                                                5,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          menuItemStyleData: MenuItemStyleData(
                                                                            height:
                                                                                40.h,
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  16.w,
                                                                            ),
                                                                          ),
                                                                          items:
                                                                              items.map((
                                                                                String item,
                                                                              ) {
                                                                                return DropdownMenuItem(
                                                                                  value:
                                                                                      item,
                                                                                  child: Row(
                                                                                    mainAxisAlignment:
                                                                                        MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        item,
                                                                                        style: TextStyle(
                                                                                          fontSize:
                                                                                              16.r,
                                                                                          color:
                                                                                              CustomColors.textSecondary,
                                                                                          fontWeight:
                                                                                              FontWeight.w500,
                                                                                        ),
                                                                                      ),
                                                                                      if (selectedValue ==
                                                                                          item)
                                                                                        Icon(
                                                                                          Icons.check_circle,
                                                                                          color:
                                                                                              CustomColors.primary,
                                                                                          size:
                                                                                              18.r,
                                                                                        ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                          value:
                                                                              selectedValue,
                                                                          onChanged: (
                                                                            value,
                                                                          ) {
                                                                            setState(() {
                                                                              selectedValue =
                                                                                    value;
                                                                            });(
                                                                            
                                                                            );
                                                                          },
                                                                        ),
                                                                      );
  }
}