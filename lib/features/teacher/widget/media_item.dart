import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MediaItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback show;
  final VoidCallback edit;

  const MediaItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.show,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
        ),
        trailing: Row(
          mainAxisSize:MainAxisSize.min ,
          children: [
            GestureDetector(child: Icon(Icons.visibility, size: 20.r),onTap: show,),
            SizedBox(width: 10.w,),
            GestureDetector(child: Icon(Icons.edit, size: 20.r),onTap: edit,),
          ],
        ),
      ),
    );
  }
}
