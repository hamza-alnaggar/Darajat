
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/widgets/categories_section.dart';
import 'package:learning_management_system/core/widgets/category_chips.dart';
import 'package:learning_management_system/core/widgets/course_card_big.dart';
import 'package:learning_management_system/core/widgets/course_card_small.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Recommended for you",style:theme.headlineMedium ,),
              SizedBox(height: 10.h,),
              SizedBox(
                height: 280.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context,index)=>CourseCardBig(),
                  separatorBuilder: (context,index)=>SizedBox(width: 15.w,),
                  ),
              ),
              SizedBox(height: 20.h,),
              SizedBox(
                width: 350.w,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text:"Because you viewed ‘‘",style: theme.headlineMedium ),
                      TextSpan(text: "Learn Python Programming",style:theme.headlineMedium?.copyWith(
                        color: Colors.purpleAccent
                      ))
                    ]
                )),
              ),
              SizedBox(height: 10.h,),
              SizedBox(
                height: 290.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context,index)=>CourseCardSmall(),
                  separatorBuilder: (context,index)=>SizedBox(width: 15.w,),
                  ),
              ),
              SizedBox(
                height: 30.h,
              ),
              CategoriesSection(),
              CategoryChips(),
            ],
          ),
        ),
      ),
    );
  }


}