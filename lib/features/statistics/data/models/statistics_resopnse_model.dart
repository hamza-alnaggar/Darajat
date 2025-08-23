import 'package:learning_management_system/features/statistics/data/models/statistics_item_model.dart';

class StatisticsResponseModel {
  final bool status;
  final List<StatisticsItemModel> data;
  final String message;

  StatisticsResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory StatisticsResponseModel.fromJson(Map<String, dynamic> json) {
    return StatisticsResponseModel(
      status: json['status'] as bool,
      data: (json['data'] as List)
          .map((item) => StatisticsItemModel.fromJson(item))
          .toList(),
      message: json['message'] as String,
    );
  }
}