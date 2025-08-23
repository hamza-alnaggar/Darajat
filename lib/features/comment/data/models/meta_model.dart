import 'package:learning_management_system/core/databases/api/end_points.dart';

class MetaModel {
  final int ?currentPage;
  final bool ?hasMorePages;
  final int? nextPage;

  MetaModel({
    required this.currentPage,
    required this.hasMorePages,
    this.nextPage,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json[ApiKey.currentPage],
      hasMorePages: json[ApiKey.hasMorePages],
      nextPage: json[ApiKey.nextPage],
    );
  }
}