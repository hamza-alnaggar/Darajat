class BadgeModel {
  final int id;
  final String group;
  final String description;
  final bool gotTheBadge;
  final int goal;
  final String imageUrl;

  BadgeModel({
    required this.id,
    required this.group,
    required this.description,
    required this.goal,
    required this.imageUrl,
    required this.gotTheBadge,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as int,
      group: json['group'] as String,
      description: json['description'] as String,
      goal: json['goal'] as int,
      gotTheBadge: json['got_the_badge'],
      imageUrl: json['image_url'] as String,
    );
  }
}
