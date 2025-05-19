// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';

class UserSubModel {
  String lastName;
  String fistName;
  String email;
  String id ;
  String ?country;

  UserSubModel({
    required this.lastName,
    required this.fistName,
    required this.email,
    required this.id,
    required this.country,
  });
   factory UserSubModel.fromJson(Map<String, dynamic> json) {
    return UserSubModel(lastName: json[ApiKey.lastName], fistName: json[ApiKey.lastName], email: json[ApiKey.lastName], id: json[ApiKey.lastName], country: json[ApiKey.country]);
   }

}
