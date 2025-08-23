// features/statistics/data/models/statistics_item_model.dart
class StatisticsItemModel {
  final int id;
  final String title;
  final int progress;

  StatisticsItemModel({
    required this.id,
    required this.title,
    required this.progress,
  });

  factory StatisticsItemModel.fromJson(Map<String, dynamic> json) {
    return StatisticsItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
      progress: json['progress'] as int,
    );
  }
}

