// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/language_sub_model.dart';
import 'package:learning_management_system/features/student/skills/data/models/sub_models/skills_sub_models.dart';

  class UserSubModel {
    String lastName;
    String firstName;
    dynamic profileImageUrl;
    dynamic otpCode;
    String role;
    String email;
    String? id;
    List<LanguageSubModel>? languages;
    dynamic jobTitle;
    int ? jobTitleId;
    String ?linkedInUrl;
    dynamic education;
    String ?university;
    dynamic speciality;
    String ?workExperience;
    List<SkillSubModel>? skills;
    String? token;
    String? country;
    int? countryId;


  UserSubModel({
    required this.lastName,
    required this.firstName,
    required this.profileImageUrl,
    required this.otpCode,
    required this.role,
    required this.email,
    required this.id,
    this.countryId,
    required this.languages,
    required this.skills,
    required this.jobTitle,
    required this.linkedInUrl,
    required this.education,
    required this.university,
    required this.speciality,
    required this.workExperience,
    required this.token,
    this.country,
  });

  UserSubModel copyWith({
  String ?lastName,
  String ?fistName,
  dynamic profileImageUrl,
  String ?email,
  List<LanguageSubModel>? languages,
  dynamic jobTitle,
  int ? jobTitleId,
  String ?linkedInUrl,
  dynamic education,
  String ?university,
  dynamic speciality,
  String ?workExperience,
  List<SkillSubModel>? skills,
  String? country,
  int? countryId
  }) {
    return UserSubModel(
      id:  id,
      firstName: fistName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      otpCode: this.otpCode ,
      role: this.role ,
      token: this.token,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      country: country ?? this.country,
      jobTitle: jobTitle ?? this.jobTitle,
      university: university ?? this.university,
      workExperience: workExperience ?? this.workExperience,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      speciality: speciality ?? this.speciality,
      education: education ?? this.education,
      languages: languages ?? this.languages,
      skills: skills ?? this.skills,
    );
  }


  factory UserSubModel.fromJson(Map<String, dynamic> json) {
    final languagesList =
        (json[ApiKey.languages] as List<dynamic>)
            .map((language) => LanguageSubModel.fromJson(language))
            .toList();
    final skillsList =
        (json[ApiKey.skills] as List<dynamic>)
            .map((skill) => SkillSubModel.fromJson(skill))
            .toList();

    return UserSubModel(
      lastName: json[ApiKey.lastName],
      firstName: json[ApiKey.firstName],
      profileImageUrl: json[ApiKey.profileImageUrl],
      otpCode: json[ApiKey.otpCode],
      role: json[ApiKey.role],
      email: json[ApiKey.email],
      id: json[ApiKey.id],
      languages: languagesList,
      country: json[ApiKey.country],
      skills: skillsList,
      jobTitle: json[ApiKey.jobTitle],
      linkedInUrl: json[ApiKey.linkedInUrl],
      education: json[ApiKey.education],
      university: json[ApiKey.university],
      speciality: json[ApiKey.speciality],
      workExperience: json[ApiKey.workExperience],
      token: json[ApiKey.token],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    data[ApiKey.firstName] = firstName;
    data[ApiKey.lastName] = lastName;
    if (countryId != null) data[ApiKey.countryId] = countryId;
    if (jobTitleId != null) data[ApiKey.jobTitleID] = jobTitleId;
    if (linkedInUrl != null) data[ApiKey.linkedInUrl] = linkedInUrl;
    if (education != null) data[ApiKey.education] = education;
    if (university != null) data[ApiKey.university] = university;
    if (speciality != null) data[ApiKey.speciality] = speciality;
    if (workExperience != null) data[ApiKey.workExperience] = workExperience;
    if (languages != null) {
      data[ApiKey.languages] = languages!.map((v) => v.toJson()).toList();
    }
    if (skills != null) {
      data[ApiKey.skills] = skills!.map((v) => v.toJson()).toList();
    }
    
    return data;
  }
}
