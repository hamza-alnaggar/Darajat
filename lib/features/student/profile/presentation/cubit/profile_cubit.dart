// features/profile/presentation/cubit/profile_cubit.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/student/profile/data/models/change_password_profile_body.dart';
import 'package:learning_management_system/features/student/profile/data/models/sub_models/update_profile_body_sub_model.dart';
import 'package:learning_management_system/features/student/profile/data/repository/change_password_repository.dart';
import 'package:learning_management_system/features/student/profile/data/repository/get_profile_repository.dart';
import 'package:learning_management_system/features/student/profile/data/repository/update_profile_image_repository.dart';
import 'package:learning_management_system/features/student/profile/data/repository/update_profile_repository.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_state.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/language_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/skills_sub_models.dart';
import 'package:learning_management_system/features/student/skills/data/models/sub_models/skills_sub_models.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileRepository getProfileRepository;
  final UpdateProfileRepository updateProfileRepository;
  final ChangePasswordRepository changePasswordRepository;
  final UpdateProfileImageRepository updateProfileImageRepository;
  AuthResponseModel? profile;


  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  TextEditingController workExperienceController = TextEditingController();
  TextEditingController linkedInUrlController = TextEditingController();
  TextEditingController specialityController = TextEditingController();

  ProfileCubit(
    this.getProfileRepository,
    this.updateProfileRepository,
    this.changePasswordRepository,
    this.updateProfileImageRepository,
  ) : super(ProfileInitial());

  Future<void> loadProfile(int userId) async {
    emit(ProfileLoading());
    final result = await getProfileRepository.getProfile(userId);
    result.fold((failure) => emit(ProfileError(failure.errMessage)), (
      profileData,
    ) {
      profile = profileData;
      _initializeControllers(profileData);
      emit(ProfileLoaded(profile: profileData));
    });
  }

  void _initializeControllers(AuthResponseModel profileData) {
    final user = profileData.user;
    firstNameController.text = user.firstName ;
    lastNameController.text = user.lastName ;
    emailController.text = user.email;
    universityController.text = user.university ?? '';
    workExperienceController.text = user.workExperience ?? '';
    linkedInUrlController.text = user.linkedInUrl ?? '';
    specialityController.text = user.speciality ?? '';
  }

  Future<void> updateProfile(
    int? countryId,
    String? education,
    int? jobTitleId,
  ) async {
    emit(ProfileLoading());

    final body = UpdateProfileBodySubModel(
      jobTitleId: jobTitleId,
      countryId: countryId,
      lastName: lastNameController.text,
      fistName: firstNameController.text,
      linkedInUrl: linkedInUrlController.text,
      education: education,
      university: universityController.text,
      speciality: specialityController.text,
      workExperience: workExperienceController.text,
      languages: profile?.user.languages,
      skills: _prepareSkillsForUpdate(),
    );

    final result = await updateProfileRepository.updateProfile(body);
    result.fold((failure) => emit(ProfileError(failure.errMessage)), 
    (
      updatedProfile,
    ) {
      profile = updatedProfile;
emit(ProfileLoaded(profile: profile!));});
  }

  Future<void> changePassword(ChangePasswordProfileBody body) async {
    emit(ChangePasswordLoading());
    final result = await changePasswordRepository.changePasswordInProfile(body);
    result.fold(
      (failure) => emit(ChangePasswordError(failure.errMessage)),
      (success) => emit(ChangePasswordSuccess()),
    );
  }

  Future<void> updateProfileImage(File image) async {
    emit(ProfileLoading());
    final result = await updateProfileImageRepository.updateProfileImage(image);
    result.fold(
      (failure) => emit(ProfileImageUpdateError(failure.errMessage)),
      (updatedProfile) {
        profile = updatedProfile;
        emit(ProfileLoaded(profile: profile!));},
    );
  }

  // Language management
  void addLanguage(LanguageSubModel language) {
    if (profile != null) {
      final updatedLanguages = List<LanguageSubModel>.from(
        profile!.user.languages ?? [],
      );
      updatedLanguages.add(language);
      profile = AuthResponseModel(
        message: '',
        user: profile!.user.copyWith(languages: updatedLanguages),
      );
      emit(ProfileLoaded(profile: profile!));
    }
  }

  void removeLanguage(int index) {
    if (profile != null && profile!.user.languages != null) {
      final updatedLanguages = List<LanguageSubModel>.from(
        profile!.user.languages!,
      );
      updatedLanguages.removeAt(index);

      profile = AuthResponseModel(
        message: '',
        user: profile!.user.copyWith(languages: updatedLanguages),
      );
      emit(ProfileLoaded(profile: profile!));
    }
  }

  void updateLanguage(
    LanguageSubModel oldLanguage,
    CountryOrLanguageSubModel newLanguage,
    String newLevel,
  ) {
    if (profile != null && profile!.user.languages != null) {
      final updatedLanguages =
          profile!.user.languages!.map((lang) {
            if (lang == oldLanguage) {
              return LanguageSubModel(
                countryOrLanguageSubModel: newLanguage,
                level: newLevel,
              );
            }
            return lang;
          }).toList();

      profile = AuthResponseModel(
        message: '',
        user: profile!.user.copyWith(languages: updatedLanguages),
      );
      updateProfile(profile?.user.countryId, profile?.user.education, profile?.user.jobTitleId);
    }
  }

  // Skill management
  void addSkill(SkillSubModel skill) {
    if (profile != null) {
      final updatedSkills = List<SkillSubModel>.from(
        profile!.user.skills ?? [],
      );
      updatedSkills.add(skill);

      profile = AuthResponseModel(
        message: '',
        user: profile!.user.copyWith(skills: updatedSkills),
      );
      
updateProfile(profile?.user.countryId, profile?.user.education, profile?.user.jobTitleId);    }
  }

  void removeSkill(SkillSubModel skill) {
    if (profile != null && profile!.user.skills != null) {
      final updatedSkills =
          profile!.user.skills!.where((s) => s.id != skill.id).toList();

      profile = AuthResponseModel(
        message: '',
        user: profile!.user.copyWith(skills: updatedSkills),
      );
updateProfile(profile?.user.countryId, profile?.user.education, profile?.user.jobTitleId);    }
  }

  // Add this conversion method
  List<SkillsBodySubModels> _prepareSkillsForUpdate() {
    return profile?.user.skills?.map((skill) {
          return SkillsBodySubModels(skillId: skill.id);
        }).toList() ??
        [];
  }
}
