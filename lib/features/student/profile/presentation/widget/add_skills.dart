import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/features/sign_up/presentation/widgets/drop_down_countries.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';
import 'package:learning_management_system/features/student/skills/data/models/sub_models/skills_sub_models.dart';
import 'package:learning_management_system/features/student/skills/presentation/cubit/get_skills_cubit.dart';
import 'package:learning_management_system/features/student/skills/presentation/cubit/get_skills_state.dart';

class AddSkillDialog extends StatelessWidget {
  const AddSkillDialog({required this.userSkills});

  final List<SkillSubModel> userSkills; 

  @override
  Widget build(BuildContext context) {
    final skillsCubit = context.read<GetSkillsCubit>();
    final profileCubit = context.read<ProfileCubit>();
    skillsCubit.updateAvailableSkills(userSkills);

    return AlertDialog(
      title: const Text("Add Skill"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<GetSkillsCubit, GetSkillsState>(
            builder: (context, state) {
              if (skillsCubit.availableSkills.isEmpty) {
                return Text("No skills available to add");
              }
              
              return CustomDropDown<SkillSubModel>(
                selectedVal: skillsCubit.selectedSkill,
                list: skillsCubit.availableSkills, 
                hint: "Choose Your Skills",
                itemToString: (item) => item.title,
                onChanged: (value) => skillsCubit.selectSkill(value),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (skillsCubit.selectedSkill != null) {
              profileCubit.addSkill(skillsCubit.selectedSkill!);
              skillsCubit.selectSkill(null); // Reset selection
              context.pop();
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}