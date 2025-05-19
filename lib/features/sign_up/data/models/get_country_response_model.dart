import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';

class GetCountryResponseModel {
  List<CountrySubModel> countryList;

  GetCountryResponseModel({required this.countryList});

  factory GetCountryResponseModel.fromJson(Map<String, dynamic> json) {
    List<CountrySubModel> countries = (json[ApiKey.data] as List<dynamic>)
        .map((country) => CountrySubModel.fromJson(country))
        .toList(); 
    return GetCountryResponseModel(countryList: countries);
  }
}