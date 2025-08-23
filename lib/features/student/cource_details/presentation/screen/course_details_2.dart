import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key});

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool _descExpanded = false;

  final double overallRating = 4.6;
 

  final List<Map<String, dynamic>> reviews = [
    {
      'author': 'Siddhesh Walawalkar',
      'timeAgo': '2 weeks ago',
      'rating': 5,
      'comment': 'This was a well structured course which really helped me understand the Python programming language from the absolute basics. Thank you.',
    },
    {
      'author': 'D Venkata Rama Rao',
      'timeAgo': '3 weeks ago',
      'rating': 5,
      'comment': 'Teaching is excellent. Explaining complex topics also in a simple and easy way. Very precise and to the point covering all the points. Keeping things interesting. I am able to easily understand the topics in the first go itself.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Image.asset('assets/images/course.jpg', fit: BoxFit.cover,width: double.infinity,),
                  Container(color: Colors.black54),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 75.h,
                    child: Column(
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white, size: 50.r),
                        SizedBox(height: 30.h),
                        Text(
                          "Preview this course",
                          style: TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w,right: 16.w, top: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Complete Python Bootcamp From Zero to Hero in Python',
                    style:theme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w400
                    )
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Learn Python like a professional. Start from the basics and go all the way to creating your own applications and games.",
                    style: theme.titleSmall?.copyWith(
                      color: CustomColors.textSecondary,
                      fontSize: 17.sp
                    )
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Text('4.6', style:theme.bodyLarge),
                      SizedBox(width: 4.w),
                      ...List.generate(5, (_) => Icon(Icons.star, color: Colors.amber, size: 15.sp)),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text('(532,345 ratings) 2,042,017 students',
                          style: theme.bodySmall),
                  SizedBox(height: 15.h,),        
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(text: "Created by ",style: theme.bodyMedium),
                        TextSpan(
                          text: "Jose Portilla",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " and ",style: theme.bodyMedium),
                        TextSpan(
                          text: "Pierian Training",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.update, size: 20.r,
                      color: CustomColors.textSecondary
                      ),
                      SizedBox(width: 7.w),
                      Text("Last updated July 2023", style: theme.bodySmall),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  Row(
                    children: [
                      Icon(Icons.language, size: 20.r, color:CustomColors.textSecondary),
                      SizedBox(width: 7.w),
                      Text("English", style: theme.bodySmall),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  
                  SizedBox(height: 25.h,),
                  RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "RUB 999.00  ",style: theme.bodyLarge?.copyWith(fontSize: 20.sp)),
                              TextSpan(
                                text: "RUB 7,990,00",
                                style: theme.titleSmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: CustomColors.textSecondary
                                )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        Center(
                          child: AppTextButton(
                            buttonText: "Buy now",
                            onpressed: (){
                            },
                            borderRadius: 0,
                            ),
                        ),
                        SizedBox(height: 7.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size * 0.39 ,
                              child: OutlinedButton(onPressed: (){
                              
                              }, child: Text("Go to cart")),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: size * 0.39,
                              child: OutlinedButton(onPressed: (){
                              }, child: Text("Add to wishlist")),
                            )
                          ],
                        ),
          SliverToBoxAdapter(child: SizedBox(height: 30.h,)),
          SliverToBoxAdapter(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Curriculum",style:theme.headlineSmall?.copyWith(fontSize: 20.sp,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10.h,),
                  Text("23 sections - 156 lectures - 22h 14m total length",style: theme.titleSmall?.copyWith(
                    color: CustomColors.textSecondary
                  ),)
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // “This course includes”
          Text(
            'This course includes',
            style: theme.headlineSmall?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold
            )
          ),
          SizedBox(height: 12.h),
          _buildIncludeRow(Icons.ondemand_video, '22 total hours on-demand video',theme),
          _buildIncludeRow(Icons.article_outlined, '15 Articles',theme),
          _buildIncludeRow(Icons.code, '19 Coding Exercises',theme),
          _buildIncludeRow(Icons.favorite, 'Full lifetime access',theme),
          _buildIncludeRow(Icons.devices, 'Access on mobile, desktop, and TV',theme),
          _buildIncludeRow(Icons.card_membership, 'Certificate of Completion',theme),
          SizedBox(height: 30.h),

          // “Requirements”
          Text(
            'Requirements',
            style:theme.headlineSmall?.copyWith(fontSize: 20.sp,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(color: CustomColors.textSecondary, fontSize: 16.sp)),
              Expanded(
                child: Text(
                  'Access to a computer with an internet connection.',
                  style: TextStyle(color: CustomColors.textSecondary, fontSize: 16.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),

          // “Description”
          Text(
            'Description',
            style: theme.headlineSmall?.copyWith(fontSize: 20.sp,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          AnimatedCrossFade(
            firstChild: Text(
              'Become a Python Programmer and learn one of employer’s most requested skills of 2023!',
              style: TextStyle(color: CustomColors.textSecondary, fontSize: 16.sp),
            ),
            secondChild: Text(
              'Become a Python Programmer and learn one of employer’s most requested skills of 2023!\n\n'
              'This is the most comprehensive, yet straight-forward, course for the Python programming '
              'language on Udemy! Whether you have never programmed before, or you are looking to refine '
              'your Python skills, this course will take you from zero to hero.\n\n'
              'You’ll start with the basics—variables, datatypes, and control flow—and then move into '
              'functions, object-oriented programming, web scraping, working with files, and even building '
              'games and GUIs. By the end, you’ll have multiple real-world projects for your portfolio!',
              style: TextStyle(color: CustomColors.textSecondary, fontSize: 16.sp),
            ),
            crossFadeState: _descExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          GestureDetector(
            onTap: () => setState(() => _descExpanded = !_descExpanded),
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                _descExpanded ? 'Show less' : 'Show more',
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 40.h,),
          Text("Instructors",style:theme.headlineSmall?.copyWith(fontSize: 20.sp,fontWeight: FontWeight.bold),),
          SizedBox(height: 15.h,),
          Text("Jose Portilla",style:theme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 5.h,),
          Text("Head of Data Scinece at Pierian Training",style: TextStyle(fontSize: 17.sp,color: CustomColors.textSecondary,fontWeight: FontWeight.bold),),
          SizedBox(height: 5.h,),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40.r),
                child: Image.asset("assets/images/course.jpg",height: 75.h,width: 75.w,fit: BoxFit.cover,),
              ),
              SizedBox(width: 20.w ,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("4.6 Instructor rating",style: theme.titleSmall),
                  Text("1,232,142 Reviews",style:  theme.titleSmall,),
                  Text("3,345,123 Students",style:  theme.titleSmall),
                  Text("87 Courses",style:  theme.titleSmall)
                ],
              )
            ],
          ),
          SizedBox(height: 20.h,),
          AnimatedCrossFade(
            firstChild: Text(
              'Become a Python Programmer and learn one of employer’s most requested skills of 2023!Become a Python Programmer and learn one of employer’s most requested skills of 2023!\n'
              'This is the most comprehensive, yet straight-forward, course for the Python programming '
              'language on Udemy! Whether you have never programmed before, or you are looking to refine '
              'your Python skills, this course will take you from zero to hero.\n',
              style: theme.titleSmall
            ),
            secondChild: Text(
              'Become a Python Programmer and learn one of employer’s most requested skills of 2023!Become a Python Programmer and learn one of employer’s most requested skills of 2023!\n'
              'This is the most comprehensive, yet straight-forward, course for the Python programming '
              'language on Udemy! Whether you have never programmed before, or you are looking to refine '
              'your Python skills, this course will take you from zero to hero.\n'
              'You’ll start with the basics—variables, datatypes, and control flow—and then move into '
              'functions, object-oriented programming, web scraping, working with files, and even building '
              'games and GUIs. By the end, you’ll have multiple real-world projects for your portfolio!',
              style:theme.titleSmall
            ),
            crossFadeState: _descExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          GestureDetector(
            onTap: () => setState(() => _descExpanded = !_descExpanded),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                _descExpanded ? 'Show less' : 'Show more',
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        SizedBox(height: 10.h,),
        SizedBox(
          width: size.w,
          child: OutlinedButton(onPressed: (){}, child: Text('View Profile'))
          ),
          SizedBox(height: 30.h,),
          Text("Student Feedback",style: theme.headlineSmall?.copyWith(fontSize: 20.sp,fontWeight: FontWeight.bold,)), 
              SizedBox(height: 10.h,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    overallRating.toStringAsFixed(1),
                    style: theme.headlineLarge
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'course rating',
                    style: TextStyle(
                      color: CustomColors.textSecondary,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
        
        ],
      ),
    )
          )
        ],
      ),
    ))]));
  }
}

 Widget _buildIncludeRow(IconData icon, String text,TextTheme theme) {
  
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, color: CustomColors.textSecondary, size: 22.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: theme.titleSmall
            ),
          ),
        ],
      ),
    );
  }
  


  