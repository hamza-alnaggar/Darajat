// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';

class CountrySubModel {
  int id ;
  String name;

  CountrySubModel({
    required this.id,
    required this.name,
  });

  factory CountrySubModel.fromJson(Map<String, dynamic> json) {
    return CountrySubModel(id: json[ApiKey.id], name: json[ApiKey.name]);
  }

}
