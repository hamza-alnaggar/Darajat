// features/topics/data/models/topic_response_model.dart
class TopicResponseModel {
  final List<TopicModel> data;

  TopicResponseModel({
    required this.data,
  });

  factory TopicResponseModel.fromJson(Map<String, dynamic> json) {
    return TopicResponseModel(
      data: (json['data'] as List)
          .map((topic) => TopicModel.fromJson(topic))
          .toList(),
    );
  }
}

class TopicModel {
  final int id;
  final String title;

  TopicModel({
    required this.id,
    required this.title,
  });
    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      title: json['title'],
    );
  }
}