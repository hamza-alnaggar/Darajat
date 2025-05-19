import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:lottie/lottie.dart';

class Flame extends StatelessWidget {
  const Flame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('الحماسة'),
      ),
      body: Column(
        children: [
          Container(
            height: 300.h,
            width: double.infinity,
            color:CustomColors.secondary,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
              child: Stack(
                children: [
                  Positioned(
                    top:-20,
                    left: 0,
                    child: SizedBox(
                      height: 170,
                      width: 170,
                      child: Lottie.asset('assets/images/flame.json',)),
                  ),
                  Positioned(
                    right: 30,
                    top: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0",style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.sp
                        ),),
                        SizedBox(height: 10.h,),
                        Text("! يوم الحماسة ",style: TextStyle(
                          color: Colors.white70,
                          fontSize: 23.sp
                        ),)
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}