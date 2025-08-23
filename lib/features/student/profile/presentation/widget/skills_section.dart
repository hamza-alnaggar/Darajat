import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/widget/add_skills.dart';
import 'package:learning_management_system/features/student/skills/data/models/sub_models/skills_sub_models.dart';
import 'package:learning_management_system/features/student/skills/presentation/cubit/get_skills_cubit.dart';

class SkillsSection extends StatelessWidget {
  final AuthResponseModel profile;

  const SkillsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    final skills = profile.user.skills ?? [];

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? CustomColors.secondary : CustomColors.lightContainer,
            borderRadius: BorderRadius.circular(17.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Skills", style: theme.bodyLarge),
                    IconButton(
                      icon: Icon(Icons.add, color: CustomColors.primary),
                      onPressed: () => _showAddSkillDialog(context,skills),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills
                      .map((skill) => Chip(
                            label: Text(skill.title),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () => _deleteSkill(context, skill),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _deleteSkill(BuildContext context, SkillSubModel skill) {
    context.read<ProfileCubit>().removeSkill(skill);
  }

  void _showAddSkillDialog(BuildContext context,List<SkillSubModel>userSkill) {
    showDialog(
      context: context,
      builder: (ctx) => MultiBlocProvider(
          providers: [
              BlocProvider.value(
              value: context.read<GetSkillsCubit>(),
            ),
              BlocProvider.value(
              value: context.read<ProfileCubit>(),
            ),
          ],
                  child:AddSkillDialog(userSkills:userSkill,),
      ),
    );
  }
}