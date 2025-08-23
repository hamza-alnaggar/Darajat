// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';

class CountryOrLanguageSubModel {
  int id ;
  String name;

  CountryOrLanguageSubModel({
    required this.id,
    required this.name,
  });

    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryOrLanguageSubModel &&
          runtimeType == other.runtimeType &&     
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;


  factory CountryOrLanguageSubModel.fromJson(Map<String, dynamic> json,bool isJobTilte) {
    return CountryOrLanguageSubModel(id: json[ApiKey.id], name:isJobTilte ? json[ApiKey.title]:json[ApiKey.name]);
  }
  

}
