import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';

class DropDownCountries extends StatefulWidget {
  const DropDownCountries({super.key,required this.countryList,required this.selectedCountry});

  final CountrySubModel? selectedCountry;
  final List<CountrySubModel> countryList;

  @override
  State<DropDownCountries> createState() => _DropDownCountriesState();
}

class _DropDownCountriesState extends State<DropDownCountries> {
  @override
  Widget build(BuildContext context) {
  String? selectedValue;
  final isDark = Theme.of(context).brightness == Brightness.dark;
    return  DropdownButtonHideUnderline(
      
                                                                        child: DropdownButton2<CountrySubModel>(
                                                                          
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
                                                                                "Choose Country",
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
                                                                            [ ...widget.countryList.map((
                                                                            country,
                                                                              ){
                                                                                return DropdownMenuItem(
                                                                                  value:
                                                                                      country,
                                                                                  child: Row(
                                                                                    mainAxisAlignment:
                                                                                        MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        country.name,
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
                                                                                          country.name)
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
                                                                              })],
                                                                          value:
                                                                              widget.selectedCountry,
                                                                          onChanged: (
                                                                            value,
                                                                          ) {
                                                                            setState(() {
                                                                              selectedValue =
                                                                                    value!.name;
                                                                            });(
                                                                            );
                                                                            context.read<GetCountryCubit>().selectCountry(value!);
                                                                          },
                                                                        ),
                                                                      );
  }
}