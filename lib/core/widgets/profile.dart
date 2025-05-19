import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_form_field.dart';
import 'package:learning_management_system/core/widgets/drop_down.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  String? selectedValue;
  List<String> items = ['Male', 'Female', "Ai", "Robot", "Ghost"];
  bool isEducationOpen = false;
  bool isBadgesOpen = false;
  bool editSecondInfoShow = false;
  bool editMainInfoShow = false;

  List<bool> earnedBadges = [true, false, true, false, true, false, true, false];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 350.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color:isDark?CustomColors.secondary : CustomColors.lightContainer,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            userImage(),
                            editUserImgae(),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility, color:isDark? CustomColors.white:CustomColors.dark),
                            SizedBox(width: 10.w),
                            Text(
                              "Only visible to you",
                              style: theme.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'حمزة النجار',
                          style:theme.headlineSmall?.copyWith(fontSize: 20.r)
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Less than 1 years experience',
                          style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w400)
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          'Syrian Arab Republic',
                          style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w400)
                        ),
                      ],
                    ),
                  ),
                ),
                editUserInfo(isDark),
              editMainInfoShow? Positioned(
                  top: 20.h,
                  right: 40.w,
                  child: editContianer(context,isDark)
                  ):SizedBox.shrink()
              ],
            ),
            SizedBox(height: 30.h),
            userInfoContainer(isDark, theme, "Education"),
            SizedBox(height: 10.h,),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isEducationOpen ? educationContent(isDark, theme, context) : SizedBox.shrink(),
            ),
            SizedBox(height: 10.h),
            userInfoContainer(isDark, theme, "Badges"),
            SizedBox(height: 10.h,),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isBadgesOpen ? badgesContent(isDark) : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Container badgesContent(bool isDark) {
    return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                        color:isDark? CustomColors.secondary : CustomColors.lightContainer,
                        borderRadius: BorderRadius.circular(17.r),
                        
                      ),
                      child: Padding(padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 15.h,
                        ),
                      child: BadgesList(earnedBadges: earnedBadges),
                        ),
          );
  }

  Container educationContent(bool isDark, TextTheme theme, BuildContext context) {
    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:isDark? CustomColors.secondary : CustomColors.lightContainer,
                        borderRadius: BorderRadius.circular(17.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 15.h,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 65.w,
                                  height: 65.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.r),
                                    color: isDark?CustomColors.primary2.withOpacity(
                                      0.2,
                                    ):CustomColors.primary.withOpacity(0.2),
                                  ),
                                  child: Icon(
                                    Icons.house,
                                    color:isDark? CustomColors.primary2 : CustomColors.primary,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Backend Engineer  ",
                                        style: theme.bodyLarge
                                      ),
                                      TextSpan(
                                        text: "Google",
                                        style: theme.bodyMedium
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                            editSecondInfoShow
                                ? Positioned(
                                  top: 0,
                                  right: 35.w,
                                  child: editContianer(context,isDark),
                                )
                                : SizedBox.shrink(),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: isDark?CustomColors.white:CustomColors.dark,
                                  size: 17,
                                ),
                                onPressed: () {
                                  setState(() {
                                    editSecondInfoShow = !editSecondInfoShow;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
  }

  Positioned editUserInfo(bool isDark) {
    return Positioned(
                top: 20.h,
                right: 10.w,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      editMainInfoShow = !editMainInfoShow;
                    });
                  },
                  icon: Icon(Icons.more_vert, color:isDark? CustomColors.white : CustomColors.dark),
                ),
              );
  }

  Container userInfoContainer(bool isDark, TextTheme theme,String title) {
    bool isOpen = title == "Education" ? isEducationOpen : isBadgesOpen;
    return Container(
              constraints: BoxConstraints(minHeight: 90.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color:isDark? CustomColors.secondary : CustomColors.lightContainer,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w400)
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                    if (title == "Education") {
                      isEducationOpen = !isEducationOpen;
                    } else {
                      isBadgesOpen = !isBadgesOpen;
                    }
                  }),
                          child: Container(
                            width: 45.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color:
                                  isOpen
                                      ? CustomColors.primary
                                      : CustomColors.primary.withOpacity(0.1),
                            ),
                            child: Icon(
                              isOpen
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_outlined,
                              color:
                                  isOpen
                                      ? Colors.white
                                      : CustomColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
  }

  Card editContianer(BuildContext context,bool isDark) {
    return Card(
                                    elevation: 5,
                                    child: Container(
                                      height: 80.h,
                                      width: 95.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 8.h,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.black,
                                                  ),
                                                  onTap: () {
                                                    editProfileDialog(context,isDark);
                                                  },
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
  }

  Future<dynamic> editProfileDialog(BuildContext context,bool isDark) {
    return showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (
                                                            context,
                                                            setStateDialog,
                                                          ) {
                                                            return Dialog(
                                                              backgroundColor:
                                                                isDark? CustomColors
                                                                      .backgroundColor:CustomColors.white,
                                                              child: Center(
                                                                child: Padding(
                                                                  
                                                                  padding:
                                                                      EdgeInsets.only(
                                                                        top:
                                                                            40.0.h,
                                                                      ),
                                                                  child: Column(
                                                                    children: [ 
                                                                      DropDown(),
                                                                      SizedBox(
                                                                        height:
                                                                            15.h,
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              14.0.w,
                                                                          vertical:
                                                                              14.h,
                                                                        ),
                                                                        child: SizedBox(
                                                                          width: 250.w,
                                                                          child: AppTextFormField(
                                                                            hintText:
                                                                                "Company",
                                                                            icon:
                                                                                Icons.home,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
  }
}

class BadgesList extends StatelessWidget {
  const BadgesList({
    super.key,
    required this.earnedBadges,
  });

  final List<bool> earnedBadges;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              itemBuilder: (context, index) {
                final isEarned = earnedBadges[index];
                
                return ColorFiltered(
                  colorFilter: 
                isEarned? 
             const ColorFilter.matrix(<double>[
                1, 0, 0, 0, 0,
    
    0, 1, 0, 0, 0,
    
    0, 0, 1, 0, 0,
    
    0, 0, 0, 1, 0,
              ])
            :const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0,      0,      0,      1, 0,
              ]),
                  child: Opacity(
                    opacity: isEarned ? 1.0 : 0.6,
                    child: 
                    Tooltip(
                      
    
      // how the text inside looks:
      textStyle: TextStyle(
        color:isDark? CustomColors.dark:CustomColors.textPrimary,
        fontSize: 14,
        height: 1.3,
      ),
    
      // space between the image and the tooltip:
      verticalOffset: 12,
    
      // force it to point “up” from the widget:
      preferBelow: false,
    
      message:
        'To earn this badge you need to complete and submit feedback for 5 peer interviews.',
      child: Image.asset(
        'assets/images/badges/century_flame.jpg',
        width: double.infinity,
        height: 240.h,
        fit: BoxFit.cover,
      ),
    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
            );
  }
}

class editUserImgae extends StatelessWidget {
  const editUserImgae({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15.r),
        ),
        width: 20.w,
        height: 20.h,
        child: Icon(
          Icons.edit,
          color: CustomColors.dark,
          size: 15.r,
        ),
      ),
    );
  }
}

class userImage extends StatelessWidget {
  const userImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: CustomColors.primary,
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: CustomColors.white,
          size: 70.r,
        ),
      ),
    );
  }
}
