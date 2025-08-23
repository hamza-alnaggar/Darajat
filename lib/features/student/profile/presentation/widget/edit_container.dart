import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/student/profile/presentation/widget/edit_option.dart';

class EditContainer extends StatelessWidget {
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EditContainer({
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: 80.h,
        width: 95.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Column(
            children: [
              EditOption(
                icon: Icons.edit,
                label: "Edit",
                color: Colors.black,
                onTap: onEdit,
              ),
              SizedBox(height: 8.h),
              EditOption(
                icon: Icons.delete,
                label: "Delete",
                color: Colors.red,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}