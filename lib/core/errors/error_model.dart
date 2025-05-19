import 'package:learning_management_system/core/databases/api/end_points.dart';

class ErrorModel {

  final String errorMessage;

  ErrorModel({required this.errorMessage});
  factory ErrorModel.fromJson(Map<String,dynamic> json) {
    return ErrorModel(
      errorMessage: json[ApiKey.message],
    );
  }
}
