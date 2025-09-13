import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class ProfessionalInfoSection extends StatelessWidget {
  final AuthResponseModel profile;
  final bool isDark;

  const ProfessionalInfoSection({
    required this.profile,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = profile.user;
    final cardColor = isDark ? CustomColors.darkContainer : CustomColors.lightContainer;
    final textColor = isDark ? CustomColors.white : CustomColors.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.jobTitle != null) ...[
            _buildInfoTile(
              icon: Icons.work_outline,
              title: "Role",
              value: user.jobTitle!.name,
              color: textColor,
            ),
            SizedBox(height: 16.h),
          ],
          if (user.languages != null && user.languages!.isNotEmpty) ...[
            _buildInfoTile(
              icon: Icons.language,
              title: "Languages",
              value: user.languages!
                  .map((e) => e.countryOrLanguageSubModel.name)
                  .join(', '),
              color: textColor,
            ),
            SizedBox(height: 16.h),
          ],
          if (user.skills != null && user.skills!.isNotEmpty) ...[
            _buildInfoTile(
              icon: Icons.man,
              title: "Skills",
              value: user.skills!
                  .map((e) => e.title)
                  .join(', '),
              color: textColor,
            ),
            SizedBox(height: 16.h),
          ],
          if(profile.user.country!=null)
            _buildInfoTile(
              icon: Icons.location_pin,
              title: "Location",
              value: user.country!.name,
              color: textColor,
            ),
          if (user.university != null) ...[
            SizedBox(height: 16.h),
            _buildInfoTile(
              icon: Icons.school,
              title: "Education",
              value: user.university!,
              color: textColor,
            ),
          ],
          if (user.speciality != null) ...[
            SizedBox(height: 16.h),
            _buildInfoTile(
              icon: Icons.psychology,
              title: "Speciality",
              value: user.speciality!,
              color: textColor,
            ),
          ],
          if (user.workExperience != null) ...[
            SizedBox(height: 16.h),
            _buildInfoTile(
              icon: Icons.work,
              title: "workExperience",
              value: user.workExperience!,
              color: textColor,
            ),
          ],
          if (user.linkedInUrl != null) ...[
            SizedBox(height: 16.h),
            _buildInfoTile(
              icon: Icons.link,
              title: "linkedInUrl",
              value: user.linkedInUrl!,
              color: textColor,
            ),
          ],
          if (user.speciality != null) ...[
            SizedBox(height: 16.h),
            _buildInfoTile(
              icon: Icons.psychology,
              title: "Speciality",
              value: user.speciality!,
              color: textColor,
            ),
          ],
          if (user.education != null) ...[
            SizedBox(height: 16.h),
            _buildInfoTile(
              icon: Icons.school,
              title: "education",
              value: user.education!,
              color: textColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.r, color: color),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.r,
                  color: color.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.r,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
