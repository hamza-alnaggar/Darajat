import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/language_sub_model.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/widgets/drop_down_countries.dart';
import 'package:learning_management_system/features/student/levels/presentation/cubit/get_levels_cubit.dart';
import 'package:learning_management_system/features/student/levels/presentation/cubit/get_levels_state.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';

class EditLanguageDialog extends StatefulWidget {
  final LanguageSubModel? language;

  const EditLanguageDialog({super.key, this.language});

  @override
  State<EditLanguageDialog> createState() => _EditLanguageDialogState();
}

class _EditLanguageDialogState extends State<EditLanguageDialog> {
  CountryOrLanguageSubModel? _selectedLanguage;
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
    if (widget.language != null) {
      _selectedLanguage = widget.language!.countryOrLanguageSubModel;
      _selectedLevel = widget.language!.level;
    }
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.language != null ? "Edit Language" : "Add Language"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<GetLanguageCubit, GetLanguageState>(
  builder: (context, state) {
    final cubit = context.read<GetLanguageCubit>();
    List<CountryOrLanguageSubModel> languagesToShow = cubit.availableLanguage;

    if (widget.language != null) {
      final currentLanguage = widget.language!.countryOrLanguageSubModel;
      if (!languagesToShow.any((lang) => lang.id == currentLanguage.id)) {
        languagesToShow = List.from(languagesToShow)..add(currentLanguage);
      }
    }

    return CustomDropDown<CountryOrLanguageSubModel>(
      selectedVal: _selectedLanguage,
      list: languagesToShow, 
      hint: "Choose Language",
      itemToString: (item) => item.name,
      onChanged: (value) => setState(() => _selectedLanguage = value),
    );
  },
),
            SizedBox(height: 25.h),
            BlocBuilder<GetLevelsCubit, GetLevelsState>(
              builder: (context, state) {
                final cubit = context.read<GetLevelsCubit>();
                return CustomDropDown<String>(
                  selectedVal: _selectedLevel,
                  list: cubit.levels,
                  hint: "Proficiency Level",
                  itemToString: (item) => item,
                  onChanged: (value) => setState(() => _selectedLevel = value),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_selectedLanguage != null && _selectedLevel != null) {
              if (widget.language != null) {
                // Update existing language
                context.read<ProfileCubit>().updateLanguage(
                  widget.language!,
                  _selectedLanguage!,
                  _selectedLevel!
                );
              } else {
                // Add new language
                context.read<ProfileCubit>().addLanguage(
                  LanguageSubModel(countryOrLanguageSubModel: _selectedLanguage!, level: _selectedLevel!)
                );
              }
              context.pop();
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}