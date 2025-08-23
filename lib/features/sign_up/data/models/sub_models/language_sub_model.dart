// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';

class LanguageSubModel {
  CountryOrLanguageSubModel countryOrLanguageSubModel;
  String level;
  bool isOpen;

  LanguageSubModel({
    required this.countryOrLanguageSubModel,
    required this.level,
    this.isOpen = false
  });

  factory LanguageSubModel.fromJson(Map<String, dynamic> json) {
    return LanguageSubModel(countryOrLanguageSubModel:CountryOrLanguageSubModel.fromJson(json, false), level: json[ApiKey.level]);
  }
  Map<String, dynamic> toJson() => {
    ApiKey.languageId: countryOrLanguageSubModel.id,
    ApiKey.level: level,
  };

}
