import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/language_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/skills_sub_models.dart';

class UpdateProfileBodySubModel {
  String lastName;
  String fistName;
  List<LanguageSubModel>? languages;
  int? jobTitleId;
  dynamic education;
  String? university;
  dynamic speciality;
  dynamic linkedInUrl;
  String? workExperience;
  List<SkillsBodySubModels>? skills;
  int? countryId;

  UpdateProfileBodySubModel({
    required this.lastName,
    required this.fistName,
    this.languages,
    this.jobTitleId,
    required this.linkedInUrl,
    required this.education,
    required this.university,
    required this.speciality,
    required this.workExperience,
    this.skills,
    this.countryId,
  });

  factory UpdateProfileBodySubModel.fromJson(Map<String, dynamic> json) {
    final languagesList = (json[ApiKey.languages] as List<dynamic>)
        .map((language) => LanguageSubModel.fromJson(language))
        .toList();
    
    final skillsList = (json[ApiKey.skills] as List<dynamic>)
        .map((skill) => SkillsBodySubModels.fromJson(skill))
        .toList();

    return UpdateProfileBodySubModel(
      lastName: json[ApiKey.lastName],
      fistName: json[ApiKey.firstName] ?? '', 
      languages: languagesList,
      skills: skillsList,
      linkedInUrl: json[ApiKey.linkedInUrl],
      education: json[ApiKey.education],
      university: json[ApiKey.university],
      speciality: json[ApiKey.speciality],
      workExperience: json[ApiKey.workExperience],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    data[ApiKey.firstName] = fistName;
    data[ApiKey.lastName] = lastName;
    if (countryId != null) data[ApiKey.countryId] = countryId;
    if (jobTitleId != null) data[ApiKey.jobTitleID] = jobTitleId;
    if (linkedInUrl != null&& linkedInUrl!.isNotEmpty) data[ApiKey.linkedInUrl] = linkedInUrl;
    if (education != null) data[ApiKey.education] = education;
    if (university != null && university!.isNotEmpty) data[ApiKey.university] = university;
    if (speciality != null && speciality.isNotEmpty) data[ApiKey.speciality] = speciality;
    if (workExperience != null && workExperience!.isNotEmpty) data[ApiKey.workExperience] = workExperience;
    
    if (languages != null) {
      data[ApiKey.languages] = languages!.map((lang) => lang.toJson()).toList();
    }
    
    if (skills != null) {
      data[ApiKey.skills] = skills!.map((skill) => skill.toJson()).toList();
    }
    
    return data;
  }
}