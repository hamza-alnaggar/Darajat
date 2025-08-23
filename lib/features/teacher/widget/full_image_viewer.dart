import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullImageViewer extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onClose;

  const FullImageViewer({required this.imageBytes, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20.w),
      child: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: IconButton(
              icon: Icon(Icons.close, size: 28.r, color: Colors.white),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
