import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/student/educations/presentation/cubit/get_educations_cubit.dart';
import 'package:learning_management_system/features/student/job_titles/presentation/cubit/job_title_cubit.dart';
import 'package:learning_management_system/features/student/levels/presentation/cubit/get_levels_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_state.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/language_sub_model.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/widget/badges_section.dart';
import 'package:learning_management_system/features/student/profile/presentation/widget/edit_container.dart';
import 'package:learning_management_system/features/student/profile/presentation/widget/edit_language_dialoge.dart';
import 'package:learning_management_system/features/student/profile/presentation/widget/edit_main_info_dialoge.dart';
import 'package:learning_management_system/features/student/profile/presentation/widget/profitional_info_section.dart';
import 'package:learning_management_system/features/student/profile/presentation/widget/skills_section.dart';
import 'package:learning_management_system/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  final bool isUser; 
  
  const ProfileScreen({super.key, required this.isUser});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey _editButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: BlocBuilder<ProfileCubit, ProfileState>(
    builder: (context, state) {
      if (state is ProfileLoading) {
        return Skeletonizer(
          enabled: true,
          child: _buildSkeletonContent(context), // Show skeleton UI
        );
      } else if (state is ProfileLoaded) {
        return _buildProfileContent(state.profile);
      } else if (state is ProfileError) {
        return Center(child: Text(state.message));
      }
      return const SizedBox();
    },
  ),
);
  }

// Skeleton content for loading state


  Widget _buildProfileContent(AuthResponseModel profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Conditionally show content based on user role
    return widget.isUser 
      ? _buildFullProfile(profile, isDark)
      : _buildProfileHeaderOnly(profile, isDark);
  }

  // Full profile for teachers
  Widget _buildFullProfile(AuthResponseModel profile, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: ListView(
          children: [
            Stack(
              children: [
                _ProfileHeader(profile: profile, isEditable: true),
                Positioned(
                  key: _editButtonKey,
                  top: 20.h,
                  right: 10.w,
                  child: _EditButton(
                    isDark: isDark,
                    onPressed: () => _showMainEditDialog(profile),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
           _CollapsibleSection(
  title: S.of(context).Languages,
  content: _LanguagesSection(profile: profile),
),
SizedBox(height: 10.h),
_CollapsibleSection(
  title: S.of(context).Skills,
  content: SkillsSection(profile: profile),
),
SizedBox(height: 10.h),
_CollapsibleSection(
  title: S.of(context).Badges,
  content: BadgesSection(isDark: isDark),
),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  _SettingsTile(
  isDark: isDark,
  icon: Icons.language,
  title: S.of(context).App_Language,
  trailing: _LanguageDropdown(isDark: isDark),
),
                  Divider(height: 1, indent: 20.w, endIndent: 20.w),

_SettingsTile(
  isDark: isDark,
  icon: Icons.school,
  title: S.of(context).Become_a_Teacher,
  onTap: () => _showPromoteDialog(context),
),
                  Divider(height: 1, indent: 20.w, endIndent: 20.w),

_SettingsTile(
  isDark: isDark,
  icon: Icons.logout,
  title: S.of(context).Sign_Out,
  textColor: Colors.red,
  onTap: () => _confirmSignOut(context),
),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Only profile header for students
  Widget _buildProfileHeaderOnly(AuthResponseModel profile, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: _ProfileHeader(profile: profile, isEditable: false),
      ),
    );
  }
  

  void _showMainEditDialog(AuthResponseModel profile) {
    showDialog(
      context: context,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GetCountryCubit>()),
          BlocProvider.value(value: context.read<JobTitleCubit>()),
          BlocProvider.value(value: context.read<GetEducationsCubit>()),
          BlocProvider.value(value: context.read<GetLevelsCubit>()),
          BlocProvider.value(value: context.read<ProfileCubit>()),
        ],
        child:  EditMainInfoDialog(model:  profile),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AuthResponseModel profile;
  final bool isEditable; // New flag to control edit functionality

  const _ProfileHeader({
    required this.profile,
    this.isEditable = false, // Default to non-editable
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Column(
          children: [
            // Profile Image Section
            _buildProfileImage(context, isDark),
            
            SizedBox(height: 15.h),
            Text(
              '${profile.user.firstName} ${profile.user.lastName}',
              style: theme.headlineSmall?.copyWith(fontSize: 20.r),
            ),
            SizedBox(height: 20.h),
            ProfessionalInfoSection(profile: profile, isDark: isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, bool isDark) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Profile Image
        Container(
          height: 80.h,
          width: 80.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            color: profile.user.profileImageUrl != null
                ? Colors.transparent
                : CustomColors.primary,
          ),
          child: profile.user.profileImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child:   CachedNetworkImage(
                        imageUrl: profile.user.profileImageUrl,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) => Icon(Icons.error),
),
                )
              : Icon(
                  Icons.person,
                  color: CustomColors.white,
                  size: 70.r,
                ),
        ),
        if (isEditable) ...[
          GestureDetector(
            onTap: () => _pickAndUploadImage(context),
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: isDark ? CustomColors.dark : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: isDark ? CustomColors.white : CustomColors.dark,
                size: 15.r,
              ),
            ),
          ),
        ],
      ],
    );
  }

 Future<void> _pickAndUploadImage(BuildContext context)async {
    if (!isEditable) return; // Safety check
    final cubit = context.read<ProfileCubit>();

    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image != null) {
      cubit.updateProfileImage(File(image.path));
    }
  } 
}



class _EditButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const _EditButton({required this.isDark, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.more_vert,
        color: isDark ? CustomColors.white : CustomColors.dark,
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final Widget content;

  const _CollapsibleSection({
    required this.title,
    required this.content,
  });

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;

    return Column(
      
      children: [
        Container(
          constraints: BoxConstraints(minHeight: 90.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
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
                      widget.title,
                      style: theme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    _ToggleButton(
                      isDark: isDark,
                      isOpen: isOpen,
                      onPressed: () => setState(() => isOpen = !isOpen),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isOpen ? widget.content : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final bool isDark;
  final bool isOpen;
  final VoidCallback onPressed;

  const _ToggleButton({
    required this.isDark,
    required this.isOpen,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 45.w,
        height: 36.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color:
              isOpen ? CustomColors.primary : CustomColors.primary.withOpacity(0.1),
        ),
        child: Icon(
          isOpen
              ? Icons.keyboard_arrow_up_outlined
              : Icons.keyboard_arrow_down_outlined,
          color: isOpen ? Colors.white : CustomColors.primary,
        ),
      ),
    );
  }
}

class _LanguagesSection extends StatelessWidget {
  final AuthResponseModel profile;

  const _LanguagesSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    final languages = profile.user.languages ?? [];

    return Column(
      children: [
        ListView.separated(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount: languages.length,itemBuilder: (context,i)=>_LanguageItem(
            language: languages[i],
            index: i,
            isDark: isDark,
            theme: theme,
          ),separatorBuilder: (context,index)=>SizedBox(height: 10.h,),),
        SizedBox(height: 10.h),
        _AddLanguageItem(isDark: isDark, theme: theme),
      ],
    );
  }
}

class _LanguageItem extends StatefulWidget {
  final LanguageSubModel language;
  final int index;
  final bool isDark;
  final TextTheme theme;

  const _LanguageItem({
    required this.language,
    required this.index,
    required this.isDark,
    required this.theme,
  });

  @override
  State<_LanguageItem> createState() => _LanguageItemState();
}

class _LanguageItemState extends State<_LanguageItem> {
  bool showEditMenu = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isDark
                ? CustomColors.secondary
                : CustomColors.lightContainer,
            borderRadius: BorderRadius.circular(17.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65.w,
                  height: 65.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    color: widget.isDark
                        ? CustomColors.primary2.withOpacity(0.2)
                        : CustomColors.primary.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.language,
                    color: widget.isDark
                        ? CustomColors.primary2
                        : CustomColors.primary,
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "${widget.language.countryOrLanguageSubModel.name}  ",
                        style: widget.theme.bodyLarge,
                      ),
                      TextSpan(
                          text: widget.language.level,
                          style: widget.theme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 20.h,
          right: 10.w,
          child: IconButton(
            onPressed: () => setState(() => showEditMenu = !showEditMenu),
            icon: Icon(
              Icons.more_vert,
              color: widget.isDark ? CustomColors.white : CustomColors.dark,
            ),
          ),
        ),
        if (showEditMenu)
          Positioned(
            top: 20.h,
            right: 40.w,
            child: EditContainer(
              isDark: widget.isDark,
              onEdit: () {
                setState(() => showEditMenu = false);
                _showEditLanguageDialog(context, widget.language);
              },
              onDelete: () => _deleteLanguage(context, widget.index),
            ),
          ),
      ],
    );
  }
  

  void _deleteLanguage(BuildContext context, int index) {
    context.read<ProfileCubit>().removeLanguage(index);
    setState(() => showEditMenu = false);
  }

  void _showEditLanguageDialog(
      BuildContext context, LanguageSubModel language) {
    showDialog(
      context: context,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GetLanguageCubit>()),
          BlocProvider.value(value: context.read<GetLevelsCubit>()),
          BlocProvider.value(value: context.read<ProfileCubit>()),
        ],
        child: EditLanguageDialog(language: language),
      ),
    );
  }
  
}
class _SettingsTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  const _SettingsTile({
    required this.isDark,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? (isDark ? Colors.white70 : Colors.black54)),
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: textColor ?? (isDark ? Colors.white : Colors.black),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _LanguageDropdown extends StatefulWidget {
  final bool isDark;

  const _LanguageDropdown({required this.isDark});

  @override
  State<_LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<_LanguageDropdown> {
  String? _selectedLanguage = 'English'; 

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedLanguage,
      underline: const SizedBox(),
      icon: Icon(Icons.arrow_drop_down, 
                color: widget.isDark ? Colors.white70 : Colors.black54),
      dropdownColor: widget.isDark ? CustomColors.darkContainer : Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      items: <String>['English', 'العربية'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              color: widget.isDark ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLanguage = newValue;
        });
        // Here you would add your actual language change logic
      },
    );
  }
}

// Dialogs
void _showPromoteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, size: 60.r, color: CustomColors.primary),
            SizedBox(height: 20.h),
            Text(
  S.of(context).Become_a_Teacher,
  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
),
            SizedBox(height: 16.h),
           Text(
  S.of(context).Are_you_sure_you_want_to_upgrade,
  textAlign: TextAlign.center,
  style: TextStyle(fontSize: 16.sp),
),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
  onPressed: () => Navigator.pop(ctx),
  child: Text(S.of(context).Cancel, style: TextStyle(fontSize: 16.sp)),
),
                ElevatedButton(
                  onPressed: () {
                    // Promotion logic here
                    Navigator.pop(ctx);
                    _showSuccessDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                   child: Text(S.of(context).Upgrade, style: TextStyle(fontSize: 16.sp))),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 60.r, color: Colors.green),
            SizedBox(height: 20.h),
            Text(
  S.of(context).Account_Upgraded,
  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
),
            SizedBox(height: 16.h),
            Text(
  S.of(context).You_are_now_a_verified_teacher,
  textAlign: TextAlign.center,
  style: TextStyle(fontSize: 16.sp),
),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(S.of(context).Get_Started, style: TextStyle(fontSize: 16.sp)),
            ),
          ],
        ),
      ),
    ),
  );
}

void _confirmSignOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      title: Text(S.of(context).Sign_Out, style: TextStyle(fontSize: 22.sp)),

      content: Text(S.of(context).Are_you_sure_you_want_to_sign_out, style: TextStyle(fontSize: 16.sp)),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
  child: Text(S.of(context).Cancel, style: TextStyle(color: Colors.grey[600])),
        ),
        TextButton(
          onPressed: () {
            // Sign out logic here
            Navigator.pop(ctx);
          },
          child: Text(
            S.of(context).Sign_Out,
    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
class _AddLanguageItem extends StatelessWidget {
  final bool isDark;
  final TextTheme theme;

  const _AddLanguageItem({
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddLanguageDialog(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? CustomColors.secondary
              : CustomColors.lightContainer,
          borderRadius: BorderRadius.circular(17.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            children: [
              Container(
                width: 65.w,
                height: 65.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: isDark
                      ? CustomColors.primary2.withOpacity(0.2)
                      : CustomColors.primary.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.add,
                  color: isDark
                      ? CustomColors.primary2
                      : CustomColors.primary,
                ),
              ),
              SizedBox(width: 10.w),
Text(S.of(context).Add_Language, style: theme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GetLanguageCubit>()),
          BlocProvider.value(value: context.read<GetLevelsCubit>()),
          BlocProvider.value(value: context.read<ProfileCubit>()),
        ],
        child: EditLanguageDialog(),
      ),
    );
  }
}
Widget _buildSkeletonContent(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  return SafeArea(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: ListView(
        children: [
          // Profile header skeleton
          _buildProfileHeaderSkeleton(isDark),
          
          SizedBox(height: 30.h),
          
          // Languages section skeleton
          _buildCollapsibleSkeleton("Languages", isDark),
          
          SizedBox(height: 10.h),
          
          // Skills section skeleton
          _buildCollapsibleSkeleton("Skills", isDark),
          
          SizedBox(height: 10.h),
          
          // Badges section skeleton
          _buildCollapsibleSkeleton("Badges", isDark),
          
          SizedBox(height: 20.h),
          
          // Settings section skeleton
          _buildSettingsSkeleton(isDark),
        ],
      ),
    ),
  );
}

// Skeleton for profile header
Widget _buildProfileHeaderSkeleton(bool isDark) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.r),
      color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
    ),
    padding: EdgeInsets.symmetric(vertical: 30.h),
    child: Column(
      children: [
        // Profile image skeleton
        Container(
          height: 80.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        
        SizedBox(height: 15.h),
        
        Container(
          width: 150.w,
          height: 24.h,
          color: Colors.grey.shade300,
        ),
        
        SizedBox(height: 20.h),
        
        Container(
          width: 200.w,
          height: 18.h,
          color: Colors.grey.shade300,
        ),
      ],
    ),
  );
}

Widget _buildCollapsibleSkeleton(String title, bool isDark) {
  return Column(
    children: [
      Container(
        constraints: BoxConstraints(minHeight: 90.h),
        decoration: BoxDecoration(
          color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title skeleton
            Container(
              width: 100.w,
              height: 24.h,
              color: Colors.grey.shade300,
            ),
            
            // Toggle button skeleton
            Container(
              width: 45.w,
              height: 36.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
      
      SizedBox(height: 10.h),
      
      // Content skeleton (shown by default in loading state)
      Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
          borderRadius: BorderRadius.circular(17.r),
        ),
        padding: EdgeInsets.all(15.w),
        child: Row(
          children: [
            // Icon skeleton
            Container(
              width: 65.w,
              height: 65.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: Colors.grey.shade300,
              ),
            ),
            
            SizedBox(width: 10.w),
            
            // Text skeleton
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 18.h,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 80.w,
                  height: 16.h,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

// Skeleton for settings section
Widget _buildSettingsSkeleton(bool isDark) {
  return Container(
    decoration: BoxDecoration(
      color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      children: [
        // Settings item skeleton
        _buildSettingsTileSkeleton(Icons.language, "App Language", isDark),
        Divider(height: 1, indent: 20.w, endIndent: 20.w),
        _buildSettingsTileSkeleton(Icons.school, "Become a Teacher", isDark),
        Divider(height: 1, indent: 20.w, endIndent: 20.w),
        _buildSettingsTileSkeleton(Icons.logout, "Sign Out", isDark),
      ],
    ),
  );
}

// Skeleton for individual settings tile
Widget _buildSettingsTileSkeleton(IconData icon, String title, bool isDark) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
    child: Row(
      children: [
        // Icon skeleton
        Container(
          width: 24.w,
          height: 24.h,
          color: Colors.grey.shade300,
        ),
        
        SizedBox(width: 20.w),
        
        // Text skeleton
        Container(
          width: 150.w,
          height: 20.h,
          color: Colors.grey.shade300,
        ),
        
        Spacer(),
        
        // Trailing skeleton
        Container(
          width: 24.w,
          height: 24.h,
          color: Colors.grey.shade300,
        ),
      ],
    ),
  );
}
  






