import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class buildMediaItem extends StatelessWidget {
   buildMediaItem({super.key,required this.color,required this.status,required this.fileName,required this.onReplace,required this.icon,required this.isDark,required this.onRemove,required this.type});
    String type;
    String status;
    IconData icon;
    Color color;
    String fileName;
    bool isDark;
    VoidCallback onRemove;
    VoidCallback onReplace;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
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
        fileName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        type,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey.shade600,
          fontSize: 12.sp,
        ),
      ),
      trailing:status!='approved' ?Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onReplace,
            child: 
            Icon(
              Icons.edit,
              size: 20.r,
              color: isDark ? Colors.grey.shade300 : Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: 
            Icon(
              Icons.delete,
              size: 20.r,
              color: isDark ? Colors.red.shade300 : Colors.red,
            ),
          ),
        ],
      ):null,
    );
  }
}

