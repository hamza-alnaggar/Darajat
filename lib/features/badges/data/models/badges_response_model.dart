import 'package:learning_management_system/features/badges/data/models/bages_data_model.dart';

class BadgesResponseModel {
  final bool status;
  final BadgesDataModel data;
  final String message;

  BadgesResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory BadgesResponseModel.fromJson(Map<String, dynamic> json) {
    return BadgesResponseModel(
      status: json['status'] as bool,
      data: BadgesDataModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }
}