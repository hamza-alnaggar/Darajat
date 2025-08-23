import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';

class GetCountryOrLanguageResponseModel {
  List<CountryOrLanguageSubModel> list;

  GetCountryOrLanguageResponseModel({required this.list});

  factory GetCountryOrLanguageResponseModel.fromJson(Map<String, dynamic> json,bool isJobTilte) {
    List<CountryOrLanguageSubModel> countries = (json[ApiKey.data] as List<dynamic>)
        .map((country) => CountryOrLanguageSubModel.fromJson(country,isJobTilte))
        .toList(); 
    return GetCountryOrLanguageResponseModel(list: countries);
  }
}