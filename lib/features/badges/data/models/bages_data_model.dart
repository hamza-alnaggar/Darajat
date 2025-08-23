import 'package:learning_management_system/features/badges/data/models/badge_model.dart';

class BadgesDataModel {
  final List<BadgeModel> bronze;
  final List<BadgeModel> silver;
  final List<BadgeModel> gold;

  BadgesDataModel({
    required this.bronze,
    required this.silver,
    required this.gold,
  });

  factory BadgesDataModel.fromJson(Map<String, dynamic> json) {
    return BadgesDataModel(
      bronze: (json['bronze'] as List)
          .map((badge) => BadgeModel.fromJson(badge))
          .toList(),
      silver: (json['silver'] as List)
          .map((badge) => BadgeModel.fromJson(badge))
          .toList(),
      gold: (json['gold'] as List)
          .map((badge) => BadgeModel.fromJson(badge))
          .toList(),
    );
  }
}