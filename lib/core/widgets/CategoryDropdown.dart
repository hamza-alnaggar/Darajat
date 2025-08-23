import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_state.dart';

class CategoryDropdown extends StatelessWidget {
  final Function(CategoryModel) onCategorySelected;

  const CategoryDropdown({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final cubit = context.read<CategoryCubit>();
        final selectedCategory = cubit.selectedCategory;
        final categories = cubit.categoryList;

        if (state is CategoryLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is CategoryFailure) {
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10.w),
                Expanded(child: Text('Error: ${state.errMessage}')),
              ],
            ),
          );
        }

        if (categories.isEmpty) {
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text('No categories available'),
          );
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: CustomColors.primary2.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CategoryModel>(
              value: selectedCategory,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, 
                color: Theme.of(context).primaryColor, size: 28.r),
              hint: Text('Select Category',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
              items: categories.map((CategoryModel category) {
                return DropdownMenuItem<CategoryModel>(
                  value: category,
                  child: Row(
                    children: [
                      if (category.imageUrl.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: CircleAvatar(
                            radius: 16.r,
                            backgroundImage: NetworkImage(category.imageUrl),
                          ),
                        ),
                      Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (CategoryModel? newValue) {
                if (newValue != null) {
                  cubit.selectCategory(newValue);
                  onCategorySelected(newValue);
                }
              },
              dropdownColor: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              menuMaxHeight: 300.h,
              itemHeight: 60.h,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16.sp,
              ),
              selectedItemBuilder: (BuildContext context) {
                return categories.map<Widget>((CategoryModel item) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        if (item.imageUrl.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: CircleAvatar(
                              radius: 16.r,
                              backgroundImage: NetworkImage(item.imageUrl),
                            ),
                          ),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
        );
      },
    );
  }
}