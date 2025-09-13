import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_form_field.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_speci_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_speci_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_univercity_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_univercity_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/widgets/drop_down_countries.dart';
import 'package:learning_management_system/features/student/educations/presentation/cubit/get_educations_cubit.dart';
import 'package:learning_management_system/features/student/educations/presentation/cubit/get_educations_state.dart';
import 'package:learning_management_system/features/student/job_titles/presentation/cubit/job_title_cubit.dart';
import 'package:learning_management_system/features/student/job_titles/presentation/cubit/job_title_state.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';
import 'package:learning_management_system/generated/l10n.dart';

class EditMainInfoDialog extends StatefulWidget {
  final AuthResponseModel model;

  const EditMainInfoDialog({super.key, required this.model});

  @override
  State<EditMainInfoDialog> createState() => _EditMainInfoDialogState();
}

class _EditMainInfoDialogState extends State<EditMainInfoDialog> {
  late ProfileCubit _profileCubit;
  late GetCountryCubit _countryCubit;
  late GetSpeciCubit _speciCubit;
  late GetUnivercityCubit _univercityCubit;
  late GetEducationsCubit _educationsCubit;
  late JobTitleCubit _jobTitleCubit;

  @override
  void initState() {
    super.initState();

    _profileCubit = context.read<ProfileCubit>();
    _countryCubit = context.read<GetCountryCubit>();
    _educationsCubit = context.read<GetEducationsCubit>();
    _speciCubit = context.read<GetSpeciCubit>();        
    _univercityCubit = context.read<GetUnivercityCubit>(); 
    _jobTitleCubit = context.read<JobTitleCubit>();

    _initializeValues();
  }

  void _initializeValues() {
    final user = widget.model.user;
    
    // Text controllers
    _profileCubit.firstNameController.text = user.firstName ;
    _profileCubit.lastNameController.text = user.lastName ;
    _profileCubit.universityController.text = user.university ?? '';
    _profileCubit.specialityController.text = user.speciality ?? '';
    _profileCubit.workExperienceController.text = user.workExperience?.toString() ?? '';
    _profileCubit.linkedInUrlController.text = user.linkedInUrl ?? '';
    _univercityCubit.selectedUnivercity = user.university;
    _speciCubit.selectedSpeci = user.speciality;
    _countryCubit.selectedCountry = user.country ;
    _jobTitleCubit.selectedJobTitle = user.jobTitle;    
    // Dropdown selections
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
      if (user.education != null) {
        print(user.education);
        _educationsCubit.setInitialEducation(user.education!);
      }
      if(user.speciality != null){
          _speciCubit.setInitialSpeci(user.speciality);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? CustomColors.backgroundColor : CustomColors.white,
      title: const Text("Edit Personal Info"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextFormField(
              hintText: "First Name",
              icon: Icons.person,
              controller: _profileCubit.firstNameController,
            ),
            SizedBox(height: 10.h),
            AppTextFormField(
              hintText: "Last Name",
              icon: Icons.person,
              controller: _profileCubit.lastNameController,
            ),
            SizedBox(height: 10.h),
            BlocBuilder<GetCountryCubit, GetCountryState>(
              builder: (context, state) {
                return CustomDropDown<CountryOrLanguageSubModel>(
                  selectedVal: _countryCubit.selectedCountry,
                  list: _countryCubit.countryList,
                  hint: "Choose Country",
                  itemToString: (item) => item.name,
                  onChanged: (value) => _countryCubit.selectCountry(value!),
                );
              },
            ),
            SizedBox(height: 25.h),
            BlocBuilder<GetEducationsCubit, GetEducationsState>(
              builder: (context, state) {
                return CustomDropDown<String>(
                  selectedVal: _educationsCubit.selectedEducation,
                  list: _educationsCubit.educations,
                  hint: "Education Level",
                  itemToString: (item) => item,
                  onChanged: (value) => _educationsCubit.selectEducation(value!),
                );
              },
            ),
            SizedBox(height: 25.h),
            BlocBuilder<JobTitleCubit, JobTitleState>(
              builder: (context, state) {
                return CustomDropDown<CountryOrLanguageSubModel>(
                  selectedVal: _jobTitleCubit.selectedJobTitle,
                  list: _jobTitleCubit.jobTitles,
                  hint: "Job Title",
                  itemToString: (item) => item.name,
                  onChanged: (value) => _jobTitleCubit.selectJobTitle(value!),
                );
              },
            ),
            SizedBox(height: 25.h),
            BlocBuilder<GetUnivercityCubit, GetUnivercityState>(
              builder: (context, state) {
                return CustomDropDown<String>(
                  selectedVal: _univercityCubit.selectedUnivercity,
                  list: _univercityCubit.univercityList,
                  hint: "Univercity",
                  itemToString: (item) => item,
                  onChanged: (value) => _univercityCubit.selectUnivercity(value!),
                );
              },
            ),
            SizedBox(height: 25.h),
            BlocBuilder<GetSpeciCubit, GetSpeciState>(
              builder: (context, state) {
                return CustomDropDown<CountryOrLanguageSubModel>(
                  selectedVal: _speciCubit.selectedSpeci,
                  list: _speciCubit.speciList,
                  hint: "Choose Specialiaze",
                  itemToString: (item) => item.name,
                  onChanged: (value) => _speciCubit.selectSeci(value!),
                );
              },
            ),
            SizedBox(height: 10.h),
            AppTextFormField(
              hintText: "Work Experience",
              icon: Icons.work,
              controller: _profileCubit.workExperienceController,
            ),
            SizedBox(height: 10.h),
            AppTextFormField(
              hintText: "LinkedIn Url",
              icon: Icons.link,
              controller: _profileCubit.linkedInUrlController,
            ),
          ],
        ),
      ),
      actions: [
        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(S.of(context).Cancel,),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _profileCubit.country = _countryCubit.selectedCountry;
                                _profileCubit.education =_educationsCubit.selectedEducation;
                                _profileCubit.jobTitle =  _jobTitleCubit.selectedJobTitle;
            _profileCubit.updateProfile();
            context.pop();
          },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.primary2,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(S.of(context).save,style:TextStyle(fontSize: 17.r)),
                            ),
                          ),
                        ],
                      ),
      ],
    );
  }
}